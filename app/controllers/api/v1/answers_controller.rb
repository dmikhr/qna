class Api::V1::AnswersController < Api::V1::BaseController

  authorize_resource class: Answer

  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show]

  def index
    render json: @question.answers
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @answer, serializer: AnswerFullSerializer
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
