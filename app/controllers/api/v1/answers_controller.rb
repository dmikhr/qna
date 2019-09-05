class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]

  def index
    render json: @question.answers
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    @answer.save
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
