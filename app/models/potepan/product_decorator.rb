module Potepan::ProductDecorator
  def list_up_relations(limit:)
    Spree::Product.joins(taxons: :taxonomy).
      where.not(id: id).
      where(spree_taxons: { id: taxons.ids }).
      order('spree_taxonomies.position asc').
      order(id: :desc).uniq[0..(limit - 1)]
  end

  Spree::Product.prepend self
end
