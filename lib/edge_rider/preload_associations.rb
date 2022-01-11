module EdgeRider
  module PreloadAssociations
    module PreloadAssociationsInstanceMethod
      def preload_associations(*args)
        self.class.preload_associations([self], *args)
      end
    end

    def preload_associations(*args)
      preloader = ActiveRecord::Associations::Preloader

      if preloader.method_defined?(:run) # Rails 3.2 / Rails 4
        preloader.new(*args).run
      elsif preloader.method_defined?(:preload) # Rails 5 to Rails 6.1
        preloader.new.preload(*args)
      else # Rails 7+
        records = args.first
        associations = args.second
        options = args[2] || {}
        preloader.new(records: records, associations: associations, **options).call
      end
    end

    ActiveRecord::Base.send(:extend, self)
    ActiveRecord::Base.send(:include, PreloadAssociationsInstanceMethod)
  end
end
