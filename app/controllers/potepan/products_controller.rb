class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @products = list_up_related_products(@product)
  end

  private

  def list_up_related_products(origin_product)
    list_taxonomy_ids = Spree::Taxonomy.all.order(:position).ids
    list_taxons = origin_product.taxons.order([Arel.sql('field(taxonomy_id, ?)'), list_taxonomy_ids]).
      includes(:products)
    list_product_ids = []
    list_taxons.each do |list_taxon|
      list_product_ids.concat(list_taxon.products.ids.reverse!)
    end
    list_product_ids.uniq!&.delete(origin_product.id)
    Spree::Product.where(id: list_product_ids).order([Arel.sql('field(id, ?)'), list_product_ids]).
      includes(master: [:default_price, :images])
  end
end
