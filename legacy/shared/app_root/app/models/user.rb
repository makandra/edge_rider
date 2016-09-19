class User < ActiveRecord::Base
  include AllowSettingIdOnCreate

  has_many :posts
  has_many :topics

  has_one :profile
  EdgeRider::Util.define_association self, :has_one, :active_profile,
    :conditions => { :trashed => false }, :class_name => 'Profile'
  
  has_defaults :trashed => false

end
