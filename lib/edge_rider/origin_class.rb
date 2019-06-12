module EdgeRider
  module OriginClass

    def origin_class
      scope = scoped({})
      while scope.respond_to?(:klass, true)
        scope = scope.klass
      end
      scope
    end

    ActiveRecord::Base.extend(self)

  end
end
