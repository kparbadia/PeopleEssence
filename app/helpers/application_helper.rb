module ApplicationHelper
  def body_title(body_title)
    content_for(:body_title) {body_title}
  end
end
