class User < ActiveRecord::Base
  include AllowSettingIdsOnCreate

  has_many :posts
  has_many :topics

  has_one :profile

end
