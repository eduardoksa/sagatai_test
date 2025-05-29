class Api::V1::ContasBancariasController < ApplicationController
  before_action :authorize_request

  def create
    conta = ContaBancaria.new(conta_params.merge(user: current_user))
    if conta.save
      Auditoria.create!(
        user: current_user,
        acao: 'criar_conta_bancaria',
        detalhes: { conta_id: conta.id, numero_conta: conta.numero_conta, agencia: conta.agencia }.to_json,
        ip: request.remote_ip
      )
      render json: { message: 'Conta bancária criada com sucesso!', conta: conta }, status: :created
    else
      render json: { errors: conta.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def saldo
    conta = current_user.conta_bancaria
    if conta
      render json: { saldo: conta.saldo }
    else
      render json: { error: 'Conta bancária não encontrada' }, status: :not_found
    end
  end

  private

  def conta_params
    params.require(:conta_bancaria).permit(:numero_conta, :agencia, :saldo)
  end
end
