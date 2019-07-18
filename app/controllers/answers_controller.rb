class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy select_best]

  def new; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy if current_user&.author_of?(@answer)
  end

  def update
    if current_user&.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def select_best
    if current_user&.author_of?(@answer)
      @answer.select_best
      @answer.save
    end
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
