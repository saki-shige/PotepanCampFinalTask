class Potepan::ProductsController < ApplicationController
  def index
  end

  def show
    @product = Spree::Product.find(params[:id])
  end
end
