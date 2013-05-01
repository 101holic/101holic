# == Schema Information
#
# Table name: authentications
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  provider_cd      :integer
#  uid              :string(255)
#  token            :string(255)
#  token_expires_at :datetime
#  secret           :string(255)
#  username         :string(255)
#  profile_url      :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Authentication < ActiveRecord::Base
  belongs_to :user, inverse_of: :authentications
  
  validates_presence_of :user
  
  as_enum :provider, { facebook: 0, twitter: 1 }
  validates :provider_cd,
            :presence => true,
            :uniqueness => { :scope => :user_id }
  
  validates :uid,
            :presence => true
  
  validates :token,
            :presence => true
    
end
