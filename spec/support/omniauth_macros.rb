module OmniauthMacros
  def mock_auth(provider, email)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      'provider' => provider.to_s,
      'uid' => '123545',
      'info' => { 'email' => email }
    })
  end
end
