class SearchesController < ApplicationController

  skip_authorization_check

  def index
    if params[:search].present?
      @search_results = Services::Search.call(search_categories, params[:search])
    else
      render :index
    end
  end

  private

  def search_categories
    input_params = []
    allowed_options = %i[question answer comment user]

    allowed_options.each { |allowed_option| input_params << allowed_option if params[allowed_option] }

    input_params
  end
end
