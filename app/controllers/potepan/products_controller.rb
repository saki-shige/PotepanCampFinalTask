class Potepan::ProductsController < ApplicationController
  MAX_RELATED_PRODUCTS_COUNT = 4

  def show
    @product = Spree::Product.find(params[:id])
    @products = @product.list_up_relations.
      includes(master: [:default_price, :images]).
      limit(MAX_RELATED_PRODUCTS_COUNT)
  end
end
