module ApplicationHelper
  def vote_item_id(item)
    "vote_#{item.class.name.underscore}_id_#{item.id}"
  end

  def can_vote?(item)
    return true if !(current_user&.author_of?(item) || current_user.nil?)
  end
end
