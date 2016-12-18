# The State model
class State < ApplicationRecord
  validates :name, :order, presence: true

  has_many :vehicles

  scope :ordered, -> { order(order: :asc) }

  before_validation :set_order, on: :create

  after_commit :update_higher_order_states, on: :destroy

  #
  # Use .length instead of .count to avoid hitting on the database again
  # if vehicles is already included
  #
  delegate :length, to: :vehicles, prefix: true

  def self.bulk_order_update(sorted_hash)
    states_ids = sorted_hash.keys
    transaction do
      states = State.where(id: states_ids)
      states.each do |state|
        state.order = sorted_hash[state.id.to_s]
        state.save
      end
    end
  end

  def next
    State.find_by(order: order + 1) || false
  end

  def set_order
    previous_state = State.ordered.last
    self.order = previous_state ? previous_state.order + 1 : 0
  end

  def as_json(options = {})
    super(options.merge(methods: [:vehicles_length]))
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
