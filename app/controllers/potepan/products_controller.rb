class Potepan::ProductsController < ApplicationController
  LIMIT_FOR_DISPLAY = 4

  def show
    @product = Spree::Product.find(params[:id])
    @products = @product.list_up_relations(limit_for_display: LIMIT_FOR_DISPLAY).
      includes(master: [:default_price, :images])
  end
end
