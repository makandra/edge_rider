module EdgeRider
  module PreloadAssociations
    module PreloadAssociationsInstanceMethod
      def preload_associations(*args)
        self.class.preload_associations([self], *args)
      end
    end

    def preload_associations(*args)
      preloader = ActiveRecord::Associations::Preloader

      if preloader.method_defined?(:preload) # Rails 4
        preloader.new.preload(*args)
      else
        preloader.new(records: args[0], associations: args[1]).call
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

    ActiveRecord::Base.send(:include, PreloadAssociationsInstanceMethod)

  end
end
