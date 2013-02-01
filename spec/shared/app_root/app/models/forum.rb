class Forum < ActiveRecord::Base
  include AllowSettingIdsOnCreate

  has_many :topics
  has_many :posts, :through => :topics

end
