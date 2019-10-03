class Services::Search
  def self.call(types, query)
    # какие модели доступны для поиска и имя атрибута для вывода в поиске
    type_rules = { question: :title, answer: :body, comment: :body, user: :email }

    # если в поиске не установлен ни один checkbox, поиск будет по всем типам
    types = type_rules.keys if types.empty?

    @search_results_all = []

    types.each do |type|
      search_results = type.to_s.capitalize.constantize.search(query)
      if search_results.present?
        search_results = search_results.map { |search_result| { type: type, id: search_result.id, data: search_result.send(type_rules[type])} }
        @search_results_all << search_results
      end
    end
    @search_results_all.flatten
  end
end
