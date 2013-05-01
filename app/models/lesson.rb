# == Schema Information
#
# Table name: lessons
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  url         :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Lesson < ActiveRecord::Base
  belongs_to :user
end
