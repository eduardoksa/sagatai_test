class ContaBancaria < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :transacoes, dependent: :destroy

  validates :numero, presence: true, uniqueness: { scope: :user_id }
  validates :agencia, presence: true
  validates :saldo
end
