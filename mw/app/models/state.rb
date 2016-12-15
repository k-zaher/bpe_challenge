class State < ApplicationRecord

  has_many :vehicles

  scope :ordered, -> { order(order: :asc) }

  before_create :set_order

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
end
