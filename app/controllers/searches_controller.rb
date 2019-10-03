class SearchesController < ApplicationController

  skip_authorization_check

  def index
    # byebug
    if params[:search].present?
      # @search_results = Question.search(params[:search])
      # byebug
      @search_results = Services::Search.call(search_categories, params[:search])
    else
      render :index
    end
  end

  private

  # <ActionController::Parameters {"utf8"=>"✓", "search"=>"111", "question"=>"true", "commit"=>"Find", "controller"=>"searches", "action"=>"index"} permitted: false>

  # Question 111
  # Answer qwertyuioi
  # Comment 1qwee
  # User test

  def search_categories
    input_params = []
    allowed_options = %i[question answer comment user]

    allowed_options.each { |allowed_option| input_params << allowed_option if params[allowed_option] }

    input_params
  end
end
