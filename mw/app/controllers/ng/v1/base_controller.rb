require 'base64'

class Ng::V1::BaseController < ApplicationController

  before_action :authenticate_user


  private

  def authenticate_user
    basic = ActionController::HttpAuthentication::Basic
    email, password = basic.decode_credentials(request).split(":")
    unless @current_user = User.authenticated?(email, password)
      render status: :unauthorized  and return
    end
  end
end
