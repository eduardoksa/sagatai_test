FactoryBot.define do
  factory :user do
    nome { "User #{Faker::Name.unique.first_name}" }
    email { Faker::Internet.unique.email }
    cpf { CPF.generate(true) }
    password { 'senha123' }
    password_confirmation { 'senha123' }
  end
end
