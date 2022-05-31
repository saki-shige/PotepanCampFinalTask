module ApplicationHelper
  def title_for_header(title)
    base_title = 'BIGBAG store'
    if title.empty?
      base_title
    else
      title + ' - ' + base_title
    end
  end
end
