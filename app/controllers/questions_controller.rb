class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: %i[show destroy update]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    reward = @question.reward.present? ? ' Reward was set.' : ''
    if @question.save
      redirect_to @question, notice: "Your question successfully created.#{reward}"
    else
      render :new
    end
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
    gon.question_id = @question.id
    gon.current_user_id = current_user&.id
    gon.question_author_id = @question.user_id
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def update
    @question.update(question_params)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
          'questions',
          ApplicationController.render(
            partial: 'questions/question.json',
            locals: { question: @question }
          )
        )
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                      files: [], links_attributes: [:name, :url, :_destroy],
                                      reward_attributes: [:name, :picture])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
