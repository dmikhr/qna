module SearchesHelper
  def search_result_link(params)
    # ограничиваем размер текста в поиске (особенно актуально при выводе body ответов и комментариев)
    text = params[:data].length > 20 ? "#{params[:data][0, 20]}..." : params[:data]
    if [:question].include?(params[:type])
      # динамически формируем routing helper (question_path, answer_path, etc)
      link_to text, eval("#{params[:type].to_s}_path(#{params[:id]})")
    else
      # для моделей без routing helper выводим просто текст
      text
    end
  end
end
