require 'rails_helper'

RSpec.describe ContaBancaria, type: :model do
  let(:user) { create(:user) }

  subject { build(:conta_bancaria, user: user) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without numero_conta' do
    subject.numero_conta = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without agencia' do
    subject.agencia = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without saldo' do
    subject.saldo = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with non-numeric saldo' do
    subject.saldo = 'abc'
    expect(subject).not_to be_valid
  end

  it 'is not valid with duplicate numero_conta for same user' do
    described_class.create!(user: user, numero_conta: subject.numero_conta, agencia: '0001', saldo: 500)
    expect(subject).not_to be_valid
  end

  it 'allows same numero_conta for different users' do
    described_class.create!(user: user, numero_conta: '999999', agencia: '0001', saldo: 500)
    other_user = User.create!(nome: 'Outro', email: "outro_#{SecureRandom.hex(4)}@example.com", cpf: (rand(10**10..10**11-1)).to_s, password: 'senha123', password_confirmation: 'senha123')
    conta = described_class.new(user: other_user, numero_conta: '999999', agencia: '0001', saldo: 100)
    expect(conta).to be_valid
  end
end
