class Api::V1::TransacoesController < ApplicationController
  before_action :authorize_request

  def create
    origem = current_user.conta_bancaria
    destino = ContaBancaria.find_by(id: params[:conta_destino_id])
    valor = params[:valor].to_i
    descricao = params[:descricao]

    if origem.nil? || destino.nil?
      return render json: { error: 'Conta de origem ou destino não encontrada' }, status: :not_found
    end
    if origem.id == destino.id
      return render json: { error: 'Não é possível transferir para a mesma conta' }, status: :unprocessable_entity
    end
    if valor <= 0
      return render json: { error: 'Valor inválido' }, status: :unprocessable_entity
    end
    if origem.saldo < valor
      return render json: { error: 'Saldo insuficiente' }, status: :unprocessable_entity
    end

    transacao_duplicada = Transacao.where(conta_origem_id: origem.id, conta_destino_id: destino.id, valor: valor, descricao: descricao).where('data_hora >= ?', 30.seconds.ago).exists?

    if transacao_duplicada
      return render json: { error: 'Transferência idêntica já realizada recentemente. Aguarde antes de repetir.' }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      origem.lock!
      destino.lock!
      origem.update!(saldo: origem.saldo - valor)
      destino.update!(saldo: destino.saldo + valor)
      transacao = Transacao.create!(
        conta_origem: origem,
        conta_destino: destino,
        valor: valor,
        descricao: descricao,
        data_hora: Time.current
      )
      Auditoria.create!(
        user: current_user,
        acao: 'transferencia',
        detalhes: {
          origem: origem.id,
          destino: destino.id,
          valor: valor,
          descricao: descricao
        }.to_json,
        ip: request.remote_ip
      )
      render json: { message: 'Transferência realizada com sucesso!', transacao: transacao }, status: :created
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def extrato
    conta = current_user.conta_bancaria
    return render json: { error: 'Conta bancária não encontrada' }, status: :not_found unless conta

    transacoes = Transacao.where('conta_origem_id = :id OR conta_destino_id = :id', id: conta.id)
    transacoes = transacoes.where('data_hora >= ?', params[:data_inicio]) if params[:data_inicio].present?
    transacoes = transacoes.where('data_hora <= ?', params[:data_fim]) if params[:data_fim].present?
    transacoes = transacoes.where('valor >= ?', params[:valor_minimo]) if params[:valor_minimo].present?
    if params[:tipo] == 'enviadas'
      transacoes = transacoes.where(conta_origem_id: conta.id)
    elsif params[:tipo] == 'recebidas'
      transacoes = transacoes.where(conta_destino_id: conta.id)
    end
    render json: transacoes.order(data_hora: :desc)

    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
    total = transacoes.count
    transacoes = transacoes.order(data_hora: :desc).offset((page - 1) * per_page).limit(per_page)

    render json: {
      transacoes: transacoes,
      page: page,
      per_page: per_page,
      total: total,
      total_pages: (total / per_page.to_f).ceil
    }
  end

  def agendar
    origem = current_user.conta_bancaria
    destino = ContaBancaria.find_by(id: params[:conta_destino_id])
    valor = params[:valor].to_i
    descricao = params[:descricao]
    executar_em = params[:executar_em]

    if origem.nil? || destino.nil?
      return render json: { error: 'Conta de origem ou destino não encontrada' }, status: :not_found
    end
    if origem.id == destino.id
      return render json: { error: 'Não é possível transferir para a mesma conta' }, status: :unprocessable_entity
    end
    if valor <= 0
      return render json: { error: 'Valor inválido' }, status: :unprocessable_entity
    end

    AgendarTransferenciaJob.set(wait_until: Time.parse(executar_em)).perform_later(origem.id, destino.id, valor, descricao)

    Auditoria.create!(
      user: current_user,
      acao: 'agendamento_transferencia',
      detalhes: {
        origem: origem.id,
        destino: destino.id,
        valor: valor,
        descricao: descricao,
        executar_em: executar_em
      }.to_json,
      ip: request.remote_ip
    )
    render json: { message: 'Transferência agendada com sucesso!' }, status: :accepted
  end
end
