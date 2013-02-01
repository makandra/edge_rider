# Since our specs are mostly about working with IDs, this module can be
# included in an ActiveRecord model class to allow setting the :id attribute
# on create. This is forbidden by default.
# http://stackoverflow.com/questions/431617/overriding-id-on-create-in-activerecord
module AllowSettingIdsOnCreate

  # Rails 2 has this as an instance method
  def attributes_protected_by_default
    []
  end

  # Rails 3 has this as a class method
  def self.included(base)
    base.send(:extend, self)
  end

end
