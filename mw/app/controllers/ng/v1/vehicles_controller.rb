# Vehicles Controller that inherits from Base
class Ng::V1::VehiclesController < Ng::V1::BaseController
  before_action :set_vehicle, only: [:next_state]
  def index
    render json: Vehicle.all, status: :ok
  end

  def next_state
    if @vehicle.next_state!
      render json: { vehicle: @vehicle }, status: :ok
    else
      render json: { message: 'Failed to move to next state' }, status: :forbidden
    end
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
    render status: :not_found and return unless @vehicle
  end
end
