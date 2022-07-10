module ApplicationHelper
  DEFAULT_TITLE = 'BIGBAG store'.freeze

  def title_for_header(title)
    if title.blank?
      DEFAULT_TITLE
    else
      "#{title} - #{DEFAULT_TITLE}"
    end
  end

  def assgin_link(product)
    if /.+potepan\/categories\/\d+$/.match(request.referer)
      :back
    else
      product.taxons.exists? ? potepan_category_path(product.taxons.first.id) : potepan_path
    end
  end
end
