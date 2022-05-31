module ApplicationHelper
  def title_for_header(title)
    if title.empty?
      'BIGBAG store'
    else
      title + ' - BIGBAG store'
    end
  end
end
