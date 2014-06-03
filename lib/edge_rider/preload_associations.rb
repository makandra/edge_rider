module EdgeRider
  module PreloadAssociations

    def preload_associations(*args)
      preloader = ActiveRecord::Associations::Preloader

      if preloader.method_defined?(:preload) # Rails 4
        preloader.new.preload(*args)
      else
        preloader.new(*args).run
      end
    end

    if ActiveRecord::Base.respond_to?(:preload_associations, true) # Rails 2/3.0
      ActiveRecord::Base.class_eval do
        class << self
          public :preload_associations
        end
      end
    else # Rails 3.2+
      ActiveRecord::Base.send(:extend, self)
    end

  end
end
