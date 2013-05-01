class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    oauthorize :facebook
  end
  
  def twitter
    oauthorize :twitter
  end

private

  def oauthorize(kind)
    omniauth = request.env['omniauth.auth']
    auth = Authentication.find_by_provider_cd_and_uid(Authentication.send(omniauth.provider), omniauth.uid)
    @user = auth.user if auth

    if @user # if user exists and has used this authentication before, update details and sign in
      @user.set_token_from_hash(provider_auth_hash(kind, omniauth), provider_user_hash(kind, omniauth))
      sign_in_and_redirect @user, :event => :authentication
    elsif current_user # if user exists then new authentication is being added - so update details and redirect to 
      current_user.set_token_from_hash(provider_auth_hash(kind, omniauth), provider_user_hash(kind, omniauth))
      redirect_to edit_user_registration_path
    else # create new user and new authentication
      user = User.new(provider_user_hash(kind, omniauth))
      user.authentications.build(provider_auth_hash(kind, omniauth))
      if user.save
        sign_in_and_redirect(:user, user)
      else
        session["devise.#{kind}_data"] = provider_auth_hash(kind, omniauth).merge(provider_user_hash(kind, omniauth))
        redirect_to new_user_registration_path
      end
    end
  end

  # Create provider specific hash's to populate authentication record
  def provider_auth_hash(provider, omniauth)
    case provider
    when :facebook
      {
        provider: omniauth.provider,
        uid: omniauth.uid,
        username: omniauth.info.nickname,
        profile_url: omniauth.info.urls['Facebook'],
        token: (omniauth.credentials.token rescue nil),
        token_expires_at: (Time.at(omniauth.credentials.expires_at) rescue nil),
        secret: nil
      }
    when :twitter
      {
        provider: omniauth.provider,
        uid: omniauth.uid,
        username: omniauth.info.nickname,
        profile_url: omniauth.info.urls['Twitter'],
        token: (omniauth.credentials.token rescue nil),
        token_expires_at: (Time.at(omniauth.credentials.expires_at) rescue nil),
        secret: (omniauth.credentials.secret rescue nil)
      }
    end
  end

  # Create provider specific hash's to populate user record if appropriate
  def provider_user_hash(provider, omniauth)
    case provider
    when :facebook
      {
        email: omniauth.info.email.downcase
      }
    when :twitter
      {
      }
    end
  end

end
