require 'has_defaults'

# Since our specs are mostly about working with IDs, this module can be
# included in an ActiveRecord model class to allow setting the :id attribute
# on create. This is forbidden by default.
# http://stackoverflow.com/questions/431617/overriding-id-on-create-in-activerecord
module AllowSettingIdOnCreate

  module RemoveIdFromProtectedAttributes
    def attributes_protected_by_default
      super - ['id']
    end
  end

  def self.included(base)
    if ActiveRecord::VERSION::MAJOR < 3 # Rails 2 has this as an instance method
      base.send(:include, RemoveIdFromProtectedAttributes)
    else # Rails 3 has this as a class method
      base.send(:extend, RemoveIdFromProtectedAttributes)
    end
  end

end




class Forum < ActiveRecord::Base
  include AllowSettingIdOnCreate

  has_many :topics
  has_many :posts, :through => :topics
  EdgeRider::Util.define_association self, :has_many, :active_topics,
    :conditions => { :trashed => false }, :class_name => 'Topic'

  has_defaults :trashed => false

end


class Post < ActiveRecord::Base
  include AllowSettingIdOnCreate

  belongs_to :topic
  belongs_to :author, :class_name => 'User'

  has_defaults :trashed => false

  EdgeRider::Util.define_scope self, :these, lambda { |array| { :conditions => { :id => array } } }

end


class Profile < ActiveRecord::Base
  include AllowSettingIdOnCreate

  belongs_to :user

  has_defaults :trashed => false

end


class Topic < ActiveRecord::Base
  include AllowSettingIdOnCreate

  belongs_to :forum
  EdgeRider::Util.define_association self, :belongs_to, :active_forum,
    :conditions => { :trashed => false }, :class_name => 'Forum'

  has_many :posts
  belongs_to :author, :class_name => 'User'
  has_many :post_authors, :through => :posts

  has_defaults :trashed => false

end


class User < ActiveRecord::Base
  include AllowSettingIdOnCreate

  has_many :posts
  has_many :topics

  has_one :profile
  EdgeRider::Util.define_association self, :has_one, :active_profile,
    :conditions => { :trashed => false }, :class_name => 'Profile'

  has_defaults :trashed => false

end
