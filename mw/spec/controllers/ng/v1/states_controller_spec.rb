require 'rails_helper'

RSpec.describe Ng::V1::StatesController, type: :controller do

  describe 'DELETE destroy' do
    context "Regular User" do
      before :each do
        @state = State.first
        user = User.first
        auth_data = Base64.strict_encode64("#{user.email}:test@1234")
        request.headers.merge!('Authorization' => "Basic #{auth_data}")
        delete :destroy, params:{id: @state.id}
      end

      it "return 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "Admin User" do
      before :each do
        @state = State.first
        admin_user = User.where(admin: true).first
        auth_data = Base64.strict_encode64("#{admin_user.email}:admin@admin")
        request.headers.merge!('Authorization' => "Basic #{auth_data}")
        delete :destroy, params:{id: @state.id}
      end

      it "return 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

end
