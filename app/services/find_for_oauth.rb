class Services::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    # по ТЗ email подтверждается только, если он не был указан у oauth провайдера
    # поэтому если email есть, подтверждаем email пользователя автоматически
    user = User.where(email: email).first
    if user
      user.update!(confirmed_at: Time.now)
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password,
                          password_confirmation: password,
                          confirmed_at: Time.now)
      user.create_authorization(auth)
    end

    user
  end
end
