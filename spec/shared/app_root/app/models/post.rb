class Post < ActiveRecord::Base
  include AllowSettingIdOnCreate

  belongs_to :topic
  belongs_to :author, :class_name => 'User'

end
