module Potepan::ProductDecorator
  def list_up_relations(limit:)
    return Spree::Product.none if taxons == []

    Spree::Product.
      in_taxons(taxons).
      joins(taxons: :taxonomy).
      select("spree_products.*, MIN(spree_taxonomies.position) AS taxonomy_position").
      where.not(id: id).
      group(:id).order("taxonomy_position, id desc").
      limit(limit)
  end

  Spree::Product.prepend self
end
