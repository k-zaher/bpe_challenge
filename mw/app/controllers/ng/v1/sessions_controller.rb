class Ng::V1::SessionsController < Ng::V1::BaseController

  skip_before_action :authenticate_user

  def create
    render json: { error_message: "Email and Password are required" }, status: :bad_request  and return if !params[:email] || !params[:password]
    if @current_user = User.authenticated?(params[:email], params[:password])
      render json: { message: "Authenticated"}, status: :ok  and return
    else
      render json: { error_message: "Email or Password is invalid" }, status: :unauthorized  and return
    end
  end
end
