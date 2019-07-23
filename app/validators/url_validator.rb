# https://coderwall.com/p/ztig5g/validate-urls-in-rails
# https://stackoverflow.com/questions/7167895/rails-whats-a-good-way-to-validate-links-urls
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "URL is not valid") unless url_valid?(value)
  end

  def url_valid?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end
end
