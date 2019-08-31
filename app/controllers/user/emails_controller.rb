class User::EmailsController < ApplicationController

  skip_authorization_check

  def new; end

  def create
    if User.create_by_email(email).persisted?
      redirect_to new_user_session_path, notice: 'Check your email for confirmation instructions'
    else
      redirect_to new_user_session_path, notice: 'You can sign up'
    end
  end

  private

  def email
    params.require(:email)
  end
end
