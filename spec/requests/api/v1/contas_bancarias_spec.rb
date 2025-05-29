require 'rails_helper'

RSpec.describe 'ContasBancarias API', type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'Host' => 'localhost'
    }
  end

  describe 'POST /api/v1/contas_bancarias' do
    it 'retorna erro se dados forem inválidos' do
      post '/api/v1/contas_bancarias',
        params: {
          conta_bancaria: {
            numero_conta: '',
            agencia: ''
          }
        }.to_json,
        headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe 'GET /api/v1/contas_bancarias/saldo' do
    it 'retorna o saldo da conta do usuário' do
      conta = create(:conta_bancaria, user: user, saldo: 500)
      get '/api/v1/contas_bancarias/saldo', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['saldo']).to eq(500)
    end

    it 'retorna erro se o usuário não tem conta' do
      get '/api/v1/contas_bancarias/saldo', headers: headers
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Conta bancária não encontrada')
    end
  end
end
