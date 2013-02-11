class Profile < ActiveRecord::Base
  include AllowSettingIdOnCreate

  belongs_to :user

end
