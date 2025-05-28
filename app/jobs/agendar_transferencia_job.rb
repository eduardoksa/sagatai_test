class AgendarTransferenciaJob < ApplicationJob
  queue_as :default

  def perform(origem_id, destino_id, valor, descricao)
    origem = ContaBancaria.lock.find(origem_id)
    destino = ContaBancaria.lock.find(destino_id)
    valor = valor.to_i

    raise 'Conta de origem não encontrada' unless origem
    raise 'Conta de destino não encontrada' unless destino
    raise 'Saldo insuficiente' if origem.saldo < valor
    raise 'Valor inválido' if valor <= 0
    raise 'Não é possível transferir para a mesma conta' if origem.id == destino.id

    ActiveRecord::Base.transaction do
      origem.update!(saldo: origem.saldo - valor)
      destino.update!(saldo: destino.saldo + valor)
      Transacao.create!(
        conta_origem: origem,
        conta_destino: destino,
        valor: valor,
        descricao: descricao,
        data_hora: Time.current
      )
    end
  end
end
