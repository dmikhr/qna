module Serialized
  extend ActiveSupport::Concern

  include Rails.application.routes.url_helpers

  included do
    has_many :links
    has_many :comments
    has_many :files
  end

  def comments
    object.comments.map(&:body)
  end

  def links
    object.links.map(&:url)
  end

  def files
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end
