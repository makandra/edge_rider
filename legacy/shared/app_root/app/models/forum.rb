class Forum < ActiveRecord::Base
  include AllowSettingIdOnCreate

  has_many :topics
  has_many :posts, :through => :topics
  EdgeRider::Util.define_association self, :has_many, :active_topics,
    :conditions => { :trashed => false }, :class_name => 'Topic'

  has_defaults :trashed => false

end
