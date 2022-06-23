module Potepan::ProductDecorator
  def list_up_relations(limit: i)
    list_taxonomy_ids = Spree::Taxonomy.all.order(:position).ids
    list_taxons = taxons.order([Arel.sql('field(taxonomy_id, ?)'), list_taxonomy_ids])
    list_product_ids = []
    list_taxons.each do |list_taxon|
      list_product_ids.concat(list_taxon.products.ids.reverse!)
      list_product_ids.uniq!
      list_product_ids.delete(id)
      if list_product_ids.length >= limit
        list_product_ids = list_product_ids[0..(limit-1)]
        break
      end
    end
    Spree::Product.where(id: list_product_ids).order([Arel.sql('field(id, ?)'), list_product_ids])
  end

  Spree::Product.prepend self
end
