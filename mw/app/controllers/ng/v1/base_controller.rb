require 'base64'
# Base Controller
class Ng::V1::BaseController < ApplicationController
  before_action :authenticate_user

  private

  def authenticate_user
    basic = ActionController::HttpAuthentication::Basic
    email, password = basic.decode_credentials(request).split(':')
    render status: :unauthorized and return unless (@current_user = User.authenticated?(email, password))
  end

  def authenticate_admin
    render json: { message: 'You are not Authorized' }, status: :unauthorized and return unless @current_user.admin?
  end
end
