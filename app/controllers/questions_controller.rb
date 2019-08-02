class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: %i[show destroy update]

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
  end

  def destroy
    @question.destroy if current_user&.author_of?(@question)
    redirect_to questions_path
  end

  def update
    @question.update(question_params) if current_user&.author_of?(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                      files: [], links_attributes: [:name, :url, :_destroy],
                                      reward_attributes: [:name, :picture])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
