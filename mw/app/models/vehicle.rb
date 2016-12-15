class Vehicle < ApplicationRecord

  belongs_to :state

  before_validation  :set_default_state, on: :create

  def state_name
    state.name
  end

  def as_json(options = { })
    super((options || { }).merge({
        :methods => [:state_name]
    }))
  end

  def next_state!
    if next_state = state.next
      self.update(state_id: next_state.id)
    else
      false
    end
  end

  private

  def set_default_state
    self.state_id = State.ordered.first.id
  end
end


