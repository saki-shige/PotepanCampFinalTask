class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @products = @product.list_up_relations(limit: 4).includes(master: [:default_price, :images])
  end
end
