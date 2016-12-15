# States Controller that inherits from Base
class Ng::V1::StatesController < Ng::V1::BaseController
  before_action :authenticate_admin
  before_action :set_state, only: [:update, :destroy]

  def index
    render json: { states_list: State.ordered }, status: :ok
  end

  def create
    @state = State.new(state_params)
    if @state.save
      render json: { state: @state }, status: :ok
    else
      render json: { message: @state.errors.full_messages }, status: :forbidden
    end
  end

  def update
    if @state.update_attributes(state_params)
      render json: { state: @state }, status: :ok
    else
      render json: { message: @state.errors.full_messages }, status: :forbidden
    end
  end

  def destroy
    if @state.destroy
      render json: { state: @state }, status: :ok
    else
      render json: { message: @state.errors.full_messages }, status: :forbidden
    end
  end

  def update_order
    sorted_hash = params[:sorted_states]
    if State.bulk_order_update(sorted_hash)
      render status: :ok
    else
      render status: :forbidden
    end
  end

  private

  def state_params
    params.require(:state).permit(:name)
  end

  def set_state
    @state = State.find(params[:id])
  end
end
