class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @products = @product.list_up_relations(limit: 4)
  end
end
