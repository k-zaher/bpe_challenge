# The State model
class State < ApplicationRecord
  validates :name, :order, presence: true

  has_many :vehicles

  scope :ordered, -> { order(order: :asc) }

  before_validation :set_order, on: :create

  after_commit :update_higher_order_states, on: :destroy

  delegate :count, to: :vehicles, prefix: true

  def next
    State.find_by(order: order + 1) || false
  end

  def set_order
    self.order = 0
    previous_state = State.ordered.last
    self.order = previous_state.order + 1 if previous_state
  end

  def as_json(options = {})
    super(options.merge(methods: [:vehicles_count]))
  end

  private

  # Should be moved to a worker
  def update_higher_order_states
    higher_states = State.where('states.order > ?', order)
    ActiveRecord::Base.transaction do
      higher_states.each do |state|
        state.order -= 1
        state.save
      end
    end
  end
end
