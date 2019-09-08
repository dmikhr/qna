class Api::V1::QuestionsController < Api::V1::BaseController

  skip_authorization_check

  before_action :load_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner
    render_errors unless @question.save
  end

  def show
    render json: @question, serializer: QuestionFullSerializer
  end

  def update
    authorize! :update, @question
    render_errors unless @question.update(question_params)
  end

  def destroy
    authorize! :destroy, @question
    render_errors unless @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def render_errors
    render json: @question.errors, status: :unprocessable_entity
  end
end
