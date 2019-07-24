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
    # запрашиваем gist при первом обращении, потом достаем из базы
    # чтобы ускорить загрузку страниц с gist и уменьшить число api запросов
    if gist_text.nil?
      contents = GistService.new(gist_id).call
      update(gist_text: contents)
      contents
    else
      gist_text
    end
  end

  private

  def gist_id
    url.split('/').last
  end
end
