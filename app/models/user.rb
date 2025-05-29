class User < ApplicationRecord
  has_secure_password

  has_one :conta_bancaria

  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true
  validates :cpf, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6, maximum: 32 }
end
