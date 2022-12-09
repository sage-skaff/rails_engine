class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.exists?(params[:id])
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    elsif Item.exists?(params[:item_id])
      render json: MerchantSerializer.new(Merchant.where(id: Item.find(params[:item_id]).merchant.id).first)
    else
      render json: { error: 'Not Found' }, status: 404
    end
  end
end
