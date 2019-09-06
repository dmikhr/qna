class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :load_question, only: %i[show update destroy]

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

  def show
    render json: @question, serializer: QuestionFullSerializer
  end

  def update
    @question.update(question_params) if current_resource_owner&.author_of?(@question)
  end

  def destroy
    @question.destroy if current_resource_owner&.author_of?(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
