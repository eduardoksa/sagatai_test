require 'rails_helper'
require 'securerandom'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  subject { user }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a nome' do
    subject.nome = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without an email' do
    subject.email = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a cpf' do
    subject.cpf = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with a short password' do
    subject.password = subject.password_confirmation = '123'
    expect(subject).not_to be_valid
  end

  it 'is not valid with a long password' do
    subject.password = subject.password_confirmation = 'a' * 33
    expect(subject).not_to be_valid
  end

  it 'is not valid if password and confirmation do not match' do
    subject.password_confirmation = 'diferente'
    expect(subject).not_to be_valid
  end
end
