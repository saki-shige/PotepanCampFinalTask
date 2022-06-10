module ApplicationHelper
  DEFAULT_TITLE = 'BIGBAG store'.freeze

  def title_for_header(title)
    if title.blank?
      DEFAULT_TITLE
    else
      "#{title} - #{DEFAULT_TITLE}"
    end
  end

  def pre_action
    pre_url[:action]
  end

  def pre_controller
    pre_url[:controller]
  end

  private

  def pre_url
    Rails.application.routes.recognize_path(request.referrer)
  end
end
