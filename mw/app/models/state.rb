class State < ApplicationRecord

  has_many :vehicles

  scope :ordered, -> { order(order: :asc) }

  before_create :set_order

  after_commit :update_higher_order_states, on: :destroy

  def next
    State.find_by_order(self.order + 1) || false
  end

  def set_order
    if previous_state = State.ordered.last
      self.order = previous_state.order + 1
    else
      self.order = 0
    end
  end

  def vehicles_count
    vehicles.count
  end

  def as_json(options = { })
    super((options || { }).merge({
        :methods => [:vehicles_count]
    }))
  end

  private

  # Should be moved to a worker
  def update_higher_order_states
    higher_states = State.where('states.order > ?', self.order)
    ActiveRecord::Base.transaction do
      higher_states.each do |state|
        state.order -= 1
        state.save
      end
    end
  end
end
