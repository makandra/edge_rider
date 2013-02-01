class Profile < ActiveRecord::Base
  include AllowSettingIdsOnCreate

  belongs_to :user

end
