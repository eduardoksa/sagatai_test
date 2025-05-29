FactoryBot.define do
  factory :conta_bancaria do
    association :user
    numero_conta { SecureRandom.hex(6) }
    agencia { '0001' }
    saldo { 1000 }
  end
end
