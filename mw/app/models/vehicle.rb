# The Vehicle model
class Vehicle < ApplicationRecord
  validates :name, :desc, :state_id, presence: true

  belongs_to :state

  before_validation :set_default_state, on: :create

  delegate :name, to: :state, prefix: true

  def as_json(options = {})
    super(options.merge(methods: [:state_name]))
  end

  def next_state!
    if (next_state = state.next)
      update(state_id: next_state.id)
    else
      false
    end
  end

  private

  def set_default_state
    self.state_id = State.ordered.first.id
  end
end
