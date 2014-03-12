class Post < ActiveRecord::Base
  include AllowSettingIdOnCreate

  belongs_to :topic
  belongs_to :author, :class_name => 'User'

  has_defaults :trashed => false

  if respond_to?(:named_scope)
    named_scope :these, lambda { |array| { :conditions => { :id => array } } }
  else
    scope :these, lambda { |array| { :conditions => { :id => array } } }
  end

end
