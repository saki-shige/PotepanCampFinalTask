class Potepan::ProductsController < ApplicationController
  LIMIT_FOR_DISPLAY = 4

  def show
    @product = Spree::Product.find(params[:id])
    @products = @product.list_up_relations.
      includes(master: [:default_price, :images]).
      limit(LIMIT_FOR_DISPLAY)
  end
end
