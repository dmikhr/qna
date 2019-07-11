module ApplicationHelper
  def is_author?(item)
    current_user.present? && item.user == current_user
  end
end
