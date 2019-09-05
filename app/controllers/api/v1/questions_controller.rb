class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    render json: @questions
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner
    if @question.save
      render json: @question
    else
      render json: nil, status: :internal_server_error
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
