class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  def gist_link?
    url_parts = url.sub('https://', '').split('/')

    url.include?('gist.github.com') \
    && url_parts.size == 3 \
    && url_parts.last.match?(/[a-z0-9]/) \
    && !url_parts.last.match?(/[A-Z]/)
  end

  def gist_contents
    return gist_text unless gist_text.nil?

    contents = GistService.new.call(gist_id)
    update(gist_text: contents)
    contents
  end

  private

  def gist_id
    url.split('/').last
  end
end
