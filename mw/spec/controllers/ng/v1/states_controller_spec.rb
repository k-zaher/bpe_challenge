require 'rails_helper'

RSpec.describe Ng::V1::StatesController, type: :controller do
  let(:user) { User.first }
  let(:admin_user) { User.where(admin: true).first }
  let(:state) { State.first }
  let(:user_auth_data) { Base64.strict_encode64("#{user.email}:test@1234") }
  let(:admin_auth_data) { Base64.strict_encode64("#{admin_user.email}:admin@admin") }
  let(:ordered_states) { State.ordered.to_a }

  describe 'GET #index' do
    it_should_behave_like 'Unauthorized User' do
      before do
        get :index
      end
    end

    context 'Admin User' do
      before :each do
        request.headers['Authorization'] = "Basic #{admin_auth_data}"
        get :index
      end

      it 'return 200' do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to include('states_list')
        expect(response.body).to eql({ states_list: State.ordered.includes(:vehicles) }.to_json)
      end
    end
  end

  describe 'POST #create' do
    it_should_behave_like 'Unauthorized User' do
      before do
        post :create, params: { state: { name: 'Test State' } }
      end
    end

    context 'Admin User' do
      before :each do
        request.headers['Authorization'] = "Basic #{admin_auth_data}"
      end

      it 'return 200' do
        expect do
          post :create, params: { state: { name: 'Test State' } }
        end.to change(State, :count).by(1)
      end
    end
  end

  describe 'PUT #update' do
    it_should_behave_like 'Unauthorized User' do
      before do
        put :update, params: { id: state.id, state: { name: 'Updated Title' } }
      end
    end

    context 'Admin User' do
      let(:state) {State.first}

      before :each do
        request.headers['Authorization'] = "Basic #{admin_auth_data}"
        put :update, params: { id: state.id, state: { name: 'Updated Title' } }
        state.reload
      end

      it 'returns 200 and updates the state title' do
        expect(state.name).to eql('Updated Title')
      end
    end
  end

  describe 'DELETE #destroy' do
    it_should_behave_like 'Unauthorized User' do
      before do
        delete :destroy, params: { id: state.id }
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

  describe 'PUT #update_order' do
    it_should_behave_like 'Unauthorized User' do
      before do
        put :update_order
      end
    end

    context 'Admin User' do
      before :each do
        request.headers['Authorization'] = "Basic #{admin_auth_data}"
        ordered_states.sort_by! { rand }
        @sorted_states = Hash[ordered_states.each_with_index.map { |v, i| [v.id, i] }]
        put :update_order, params: { sorted_states: @sorted_states }
      end

      it 'return 200' do
        expect(response).to have_http_status(200)
        expect(State.ordered.pluck(:id)).to eql(@sorted_states.keys)
      end
    end
  end
end
