require 'rails_helper'

RSpec.describe Ng::V1::StatesController, type: :controller do
  let(:user) { User.first }
  let(:admin_user) { User.where(admin: true).first }
  let(:state) { State.first }
  let(:user_auth_data) { Base64.strict_encode64("#{user.email}:test@1234") }
  let(:admin_auth_data) { Base64.strict_encode64("#{admin_user.email}:admin@admin") }

  describe 'DELETE destroy' do
    context 'Regular User' do
      before :each do
        request.headers['Authorization'] = "Basic #{user_auth_data}"
        delete :destroy, params: { id: state.id }
      end

      it 'return 401' do
        expect(response).to have_http_status(401)
      end
    end
    context 'Admin User' do
      before :each do
        request.headers['Authorization'] = "Basic #{admin_auth_data}"
        delete :destroy, params: { id: state.id }
      end

      it 'return 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
