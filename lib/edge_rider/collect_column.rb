module EdgeRider
  module CollectColumn

    def collect_column(column_name, find_options = {})
      distinct = find_options.delete(:distinct)
      qualified_column_name = EdgeRider::Util.qualify_column_name(self, column_name)

      scope = scoped({})
      if distinct
        if ActiveRecord::VERSION::MAJOR < 5
          scope = scope.uniq
        else
          scope = scope.distinct
        end
      end
      scope.pluck(qualified_column_name)
    end

  end
end

ActiveSupport.on_load :active_record do
  extend(EdgeRider::CollectColumn)
end
