module Potepan::ProductDecorator
  def list_up_relations(limit:)
    list_taxons = taxons.joins(:taxonomy).order('spree_taxonomies.position asc')
    list_product_ids = []
    list_taxons.each do |list_taxon|
      list_product_ids.concat(list_taxon.products.ids.reverse!)
      list_product_ids.uniq!
      list_product_ids.delete(id)
      if list_product_ids.length >= limit
        list_product_ids = list_product_ids[0..(limit - 1)]
        break
      end
    end
    Spree::Product.find(list_product_ids).sort_by { |x| list_product_ids }
  end

  Spree::Product.prepend self
end
