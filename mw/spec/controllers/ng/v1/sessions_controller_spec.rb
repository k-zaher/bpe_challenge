require 'rails_helper'

RSpec.describe Ng::V1::SessionsController, type: :controller do

  describe "POST #Create" do
    context "Email or Password no provided" do
      it "returns bad_request" do
        post :create, params: { email: "test@test.com" }
        expect(response).to have_http_status(400)
      end
    end

    context "Email or Password not valid" do
      it "returns bad_request" do
        post :create, params: { email: "test@test.com", password: "hello"}
        expect(response).to have_http_status(401)
      end
    end

    context "Email and Password are valid" do
      it "returns bad_request" do
        user = User.first
        post :create, params: { email: user.email, password: "test@1234"}
        expect(response).to have_http_status(200)
        expect(assigns(:current_user)).to eq(User.first)
      end
    end
  end
end
