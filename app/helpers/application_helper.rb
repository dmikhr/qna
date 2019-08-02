module ApplicationHelper
  def vote_item_id(item)
    "vote_#{item.class.name.underscore}_id_#{item.id}"
  end

  # разрешить голосовать, если пользователь не автор и не гость
  # т.е. авторизованный пользователь, не являющийся автором
  def can_vote?(item)
    return true unless (current_user&.author_of?(item) || current_user.nil?)
  end
end
