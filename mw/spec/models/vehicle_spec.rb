require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  let(:vehicle) { Vehicle.first }
  let(:ordered_states) { State.ordered }

  describe '.as_json' do
    it 'responses with JSON body containing the vehicle state name' do
      expect(vehicle.as_json['state_name']).to eql(vehicle.state_name)
    end
  end

  describe '.next_state!' do
    context 'if next state exists' do
      it 'updates the vehicle state to the next state' do
        expect(vehicle.next_state!).to eql(true)
        expect(vehicle.state_id).to eql(ordered_states[1].id)
      end
    end

    context 'if next state does not exist' do
      before do
        vehicle.state = ordered_states.last
        vehicle.save
      end
      it 'does nothing' do
        expect(vehicle.next_state!).to eql(false)
        expect(vehicle.state_id).to eql(ordered_states.last.id)
      end
    end
  end

  describe '.set_default_state' do
    before do
      @vehicle = Vehicle.new(name: 'test')
      @vehicle.save
    end
    it 'sets the inital state to the vehicle' do
      expect(@vehicle.state_id).to eql(ordered_states.first.id)
    end
  end

  describe '.state_name' do
    it 'get delegated to state.name' do
      expect(vehicle.state_name).to eql(State.find(vehicle.state_id).name)
    end
  end
end
