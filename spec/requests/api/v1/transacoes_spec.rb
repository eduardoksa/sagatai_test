require 'rails_helper'

RSpec.describe 'Transacoes API', type: :request do
  let(:user) { create(:user) }
  let!(:conta_origem) { create(:conta_bancaria, user: user, saldo: 1000) }
  let(:conta_destino) { create(:conta_bancaria, saldo: 500) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base, 'HS256') }

  let(:headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'Host' => 'localhost'
    }
  end

  describe 'POST /api/v1/transferencias' do
    it 'realiza uma transferência válida' do
      post '/api/v1/transferencias',
        params: {
          conta_destino_id: conta_destino.id,
          valor: 100,
          descricao: 'Pagamento'
        }.to_json,
        headers: headers

      puts response.body
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq('Transferência realizada com sucesso!')
    end

    it 'retorna erro se saldo for insuficiente' do
      post '/api/v1/transferencias',
        params: {
          conta_destino_id: conta_destino.id,
          valor: 2000,
          descricao: 'Pagamento'
        }.to_json,
        headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Saldo insuficiente')
    end

    it 'retorna erro se tentar transferir para a mesma conta' do
      post '/api/v1/transferencias',
        params: {
          conta_destino_id: conta_origem.id,
          valor: 100,
          descricao: 'Pagamento'
        }.to_json,
        headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Não é possível transferir para a mesma conta')
    end
  end
end
