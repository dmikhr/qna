class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy select_best]

  after_action :publish_answer, only: :create

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
    @answer.select_best if current_user&.author_of?(@answer.question)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
          'answers',
          ApplicationController.render(
            partial: 'answers/answer.json',
            locals: { answer: @answer }
          )
        )
  end

  def set_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end
end
