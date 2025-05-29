require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /api/v1/users' do
    let(:valid_attributes) do
      {
        nome: 'Fulano',
        email: "user_#{SecureRandom.hex(4)}@example.com",
        cpf: CPF.generate(true),
        password: 'senha123',
        password_confirmation: 'senha123'
      }
    end

    let(:invalid_attributes) do
      {
        nome: '',
        email: '',
        cpf: '',
        password: '123',
        password_confirmation: '321'
      }
    end

    it 'creates a user with valid attributes' do
      expect {
        post '/api/v1/users', params: { user: valid_attributes }, as: :json, headers: { 'Host' => 'localhost' }
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq('Usuário criado com sucesso!')
    end

    it 'does not create a user with invalid attributes' do
      expect {
        post '/api/v1/users', params: { user: invalid_attributes }, as: :json, headers: { 'Host' => 'localhost' }
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end
end
