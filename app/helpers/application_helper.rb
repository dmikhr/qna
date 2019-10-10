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

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
