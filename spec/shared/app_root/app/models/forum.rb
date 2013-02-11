class Forum < ActiveRecord::Base
  include AllowSettingIdOnCreate

  has_many :topics
  has_many :posts, :through => :topics

end
