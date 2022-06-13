class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])
    @taxonomies = Spree::Taxonomy.includes(taxons: :products)
    @products = @taxon.products.includes(master: [:default_price, :images])
  end
end
