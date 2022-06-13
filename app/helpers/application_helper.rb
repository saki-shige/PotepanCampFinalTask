module ApplicationHelper
  DEFAULT_TITLE = 'BIGBAG store'.freeze

  def title_for_header(title)
    if title.blank?
      DEFAULT_TITLE
    else
      "#{title} - #{DEFAULT_TITLE}"
    end
  end

  def link_destination(product)
    if /.+potepan\/categories\/\d+$/.match(request.referer)
      :back
    elsif taxon_id = product.taxons.first&.id
      potepan_category_path(taxon_id)
    else
      potepan_path
    end
  end
end
