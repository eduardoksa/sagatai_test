require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'auth#login'
      post 'contas_bancarias', to: 'contas_bancarias#create'
      get 'contas_bancarias/saldo', to: 'contas_bancarias#saldo'
      post 'transferencias', to: 'transacoes#create'
      get 'extrato', to: 'transacoes#extrato'
      post 'transferencias/agendada', to: 'transacoes#agendar'
    end
  end
end
