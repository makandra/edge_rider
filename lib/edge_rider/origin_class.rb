module EdgeRider
  module OriginClass

    def origin_class
      scope = scoped({})
      if Util.activerecord2?
        # Rails 2
        while scope.respond_to?(:proxy_scope, true)
          scope = scope.proxy_scope
        end
      else
        # Rails 3
        while scope.respond_to?(:klass, true)
          scope = scope.klass
        end
      end
      scope
    end

    ActiveRecord::Base.extend(self)

  end
end
