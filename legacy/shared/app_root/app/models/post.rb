class Post < ActiveRecord::Base
  include AllowSettingIdOnCreate

  belongs_to :topic
  belongs_to :author, :class_name => 'User'

  has_defaults :trashed => false
  
  EdgeRider::Util.define_scope self, :these, lambda { |array| { :conditions => { :id => array } } }

end
