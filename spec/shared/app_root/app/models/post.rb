class Post < ActiveRecord::Base
  include AllowSettingIdsOnCreate

  belongs_to :topic
  belongs_to :author, :class_name => 'User'

end
