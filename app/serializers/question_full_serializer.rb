class QuestionFullSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at
  has_many :links
  has_many :comments
  has_many :files

  def comments
    object.comments.map { |comment| comment.body }
  end

  def links
    object.links.map { |link| link.url }
  end

  def files
    # https://github.com/rails/rails/issues/31581#issuecomment-354397873
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end
