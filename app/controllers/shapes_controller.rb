# frozen_string_literal: true

class ShapesController < AuthenticationsController
  before_action :set_shape, only: %i[update destroy]

  def create
    @shape = current_user.shapes.build(shape_params)

    respond_to do |format|
      format.json do
        if @shape.save
          render json: @shape
        else
          render json: @shape.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        if @shape.update(shape_params)
          render json: @shape
        else
          render json: @shape.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @shape.delete
    head :no_content
  end

  private

  def shape_params
    params.require(:shape).permit(:shape_type, :radius, :name, center: %i[lat lng], coordinates: %i[lat lng])
  end

  def set_shape
    @shape = current_user.shapes.find(params[:id])
  end
end
