# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
         
  has_many :authentications, inverse_of: :user, dependent: :destroy
  
  def email_required?
    super && !is_connected_to_provider?(:twitter)
  end
  
  def password_required?
    super && (authentications.empty? || !password.blank?)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data']
        user.email = data[:email]
      end
    end
  end

  def set_token_from_hash(auth_hash, user_hash)
    self.update_attributes!(email: user_hash[:email]) if self.email.blank?
    token = self.authentications.find_or_initialize_by_provider_cd_and_uid(Authentication.send(auth_hash[:provider]), auth_hash[:uid])
    token.update_attributes!(auth_hash.except(:provider, :uid))
  end
  
  def is_connected_to_provider?(provider)
    #self.authentications.find_by_provider_cd(Authentication.send(provider)).present?
    # do not use find because it does not work with a user being created with a new auth record.
    self.authentications.each do |auth|
      return true if auth.provider == provider
    end
    false
  end

end
