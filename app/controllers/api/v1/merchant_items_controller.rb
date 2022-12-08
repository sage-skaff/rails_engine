class Api::V1::MerchantItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
