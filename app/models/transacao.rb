class Transacao < ApplicationRecord
  self.table_name = "transacoes"

  belongs_to :conta_origem, class_name: 'ContaBancaria'
  belongs_to :conta_destino, class_name: 'ContaBancaria'

  validates :valor, presence: true, numericality: { greater_than: 0 }
  validates :descricao, presence: true
  validates :data_hora, presence: true

  scope :recent, -> { order(data_hora: :desc) }

  def formatted_date
    data_hora.strftime('%d/%m/%Y')
  end
end
