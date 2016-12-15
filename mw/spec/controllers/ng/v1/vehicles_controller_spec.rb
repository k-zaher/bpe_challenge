require 'rails_helper'
require "base64"

RSpec.describe Ng::V1::VehiclesController, type: :controller do

  context 'GET #index' do
    context 'with no authorization header' do
      it 'responds successfully HTTP 401 status code' do
        get :index
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:unauthorized])
      end
    end

    context 'with invalid authorization header' do
      before(:each) do
        request.headers.merge!('Authorization' => "Hello")
        get :index
      end
      it 'responds successfully HTTP 401 status code' do
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:unauthorized])
      end
    end

    context 'with valid authorization header' do
      before(:each) do
        user = User.first
        auth_data = Base64.strict_encode64("#{user.email}:test@1234")
        request.headers.merge!('Authorization' => "Basic #{auth_data}")
        get :index
      end
      it 'responds successfully HTTP 200 status code' do
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(response.body).to eq(Vehicle.all.to_json)
      end
    end
  end

  context 'PUT next_state' do
    before(:each) do
      user = User.first
      auth_data = Base64.strict_encode64("#{user.email}:test@1234")
      request.headers.merge!('Authorization' => "Basic #{auth_data}")
      @vehicle = Vehicle.first
    end

    it 'changes Designed to Assembled' do
      put :next_state, params: { id: @vehicle.id}
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["vehicle"]["state_name"]).to eq("Assembled")
    end

    it 'does not change the last state' do
      @vehicle.update(state_id: State.ordered.last.id)
      put :next_state, params: { id: @vehicle.id}
      expect(response).to have_http_status(403)
    end
  end
end
