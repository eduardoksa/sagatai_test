class ContaBancaria < ApplicationRecord
  self.table_name = "contas_bancarias"

  belongs_to :user, dependent: :destroy
  has_many :transacoes, dependent: :destroy

  validates :numero_conta, presence: true, uniqueness: { scope: :user_id }
  validates :agencia, presence: true
  validates :saldo, presence: true, numericality: true
end
