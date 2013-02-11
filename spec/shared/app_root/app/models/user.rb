class User < ActiveRecord::Base
  include AllowSettingIdOnCreate

  has_many :posts
  has_many :topics

  has_one :profile

end
