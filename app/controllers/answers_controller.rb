class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]

  def new; end

  def show; end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question
    else
      redirect_to @question, notice: "Answer can't be empty"
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
