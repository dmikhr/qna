module ApplicationHelper
  def vote_item_id(item)
    "vote_#{item.class.name.underscore}_id_#{item.id}"
  end

  def can_vote?(votable)
    return false if current_user.nil?
    return false if current_user.author_of?(votable)

    true
  end

  def commentable_label(commentable)
    "#{commentable.class.name.downcase}_#{commentable.id}"
  end
end
