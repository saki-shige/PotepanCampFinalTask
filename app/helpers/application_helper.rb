module ApplicationHelper
  DEFAULT_TITLE = 'BIGBAG store'.freeze

  def title_for_header(title)
    if title.blank?
      DEFAULT_TITLE
    else
      title + ' - ' + DEFAULT_TITLE
    end
  end
end
