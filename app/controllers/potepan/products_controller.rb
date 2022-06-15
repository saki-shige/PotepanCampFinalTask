class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @products = list_up_related_products(@product)
  end

  private

  def list_up_related_products(origin_product)
    list_taxonomies = Spree::Taxonomy.all.order(position: "ASC").ids
    list_taxons = origin_product.taxons.order([Arel.sql('field(taxonomy_id, ?)'), list_taxonomies]).includes(:products)
    list_of_products = []
    list_taxons.each do |list_taxon|
      list_of_products.concat(list_taxon.products.ids.reverse!)
    end
    list_of_products.uniq!&.delete(origin_product.id)
    Spree::Product.where(id: list_of_products).order([Arel.sql('field(id, ?)'), list_of_products]).includes(master: [:default_price, :images])
  end
end
