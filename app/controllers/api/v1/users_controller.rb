class Api::V1::UsersController < ActionController::API
  before_action :ensure_json_request

  def create
    user = User.new(user_params)
    if user.save
      Auditoria.create!(
        user: user,
        acao: 'criar_usuario',
        detalhes: { user_id: user.id, email: user.email, nome: user.nome }.to_json,
        ip: request.remote_ip
      )
      render json: { message: 'Usuário criado com sucesso!' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def ensure_json_request
    request.format = :json
  end

  def user_params
    params.require(:user).permit(:nome, :email, :cpf, :password, :password_confirmation)
  end
end
