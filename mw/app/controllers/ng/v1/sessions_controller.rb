# Sessions Controller that inherits from Base
class Ng::V1::SessionsController < Ng::V1::BaseController
  skip_before_action :authenticate_user
  before_action :validate_params

  def create
    if (@current_user = User.authenticated?(params[:email], params[:password]))
      render json: { message: 'Authenticated' }, status: :ok and return
    else
      render_unauthorized and return
    end
  end

  private

  def validate_params
    if !params[:email] || !params[:password]
      render json: { error_message: 'Email and Password are required' }, status: :bad_request
    end
  end
end
