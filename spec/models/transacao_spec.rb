require 'rails_helper'

RSpec.describe Transacao, type: :model do
  let(:user) { create(:user) }
  let(:conta_origem) { create(:conta_bancaria, user: user) }
  let(:conta_destino) { create(:conta_bancaria) }

  subject {
    described_class.new(
      conta_origem: conta_origem,
      conta_destino: conta_destino,
      valor: 100,
      descricao: 'Pagamento',
      data_hora: DateTime.now
    )
  }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without valor' do
    subject.valor = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with valor <= 0' do
    subject.valor = 0
    expect(subject).not_to be_valid
    subject.valor = -10
    expect(subject).not_to be_valid
  end

  it 'is not valid without descricao' do
    subject.descricao = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without data_hora' do
    subject.data_hora = nil
    expect(subject).not_to be_valid
  end

  it 'returns formatted_date in dd/mm/yyyy' do
    subject.data_hora = Date.new(2025, 5, 28)
    expect(subject.formatted_date).to eq('28/05/2025')
  end
end
