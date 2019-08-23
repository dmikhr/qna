class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    oauth_provider :github
  end

  def vkontakte
    oauth_provider :vkontakte
  end

  private

  def oauth_provider(provider)
    if !request.env['omniauth.auth'].info[:email]
      redirect_to user_sign_up_submit_email_path
      return
    end

    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.to_s) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
