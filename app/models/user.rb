require 'cpf_cnpj'

class User < ApplicationRecord
  has_secure_password

  has_one :conta_bancaria

  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true
  validates :cpf, presence: true, uniqueness: true
  validate :cpf_must_be_valid
  validates :password, presence: true, length: { minimum: 6, maximum: 32 }

  private

  def cpf_must_be_valid
    return if cpf.blank?
    unless CPF.valid?(cpf)
      errors.add(:cpf, 'não é válido')
    end
  end
end
