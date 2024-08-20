module EdgeRider
  module OriginClass

    def origin_class
      scope = scoped({})
      while scope.respond_to?(:klass, true)
        scope = scope.klass
      end
      scope
    end

  end
end

ActiveSupport.on_load :active_record do
  extend(EdgeRider::OriginClass)
end
