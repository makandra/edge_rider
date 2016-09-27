module EdgeRider
  module CollectColumn

    def collect_column(column_name, find_options = {})
      distinct = find_options.delete(:distinct)
      qualified_column_name = EdgeRider::Util.qualify_column_name(self, column_name)
      if respond_to?(:pluck) # Rails 3.2+
        scope = scoped({})
        if distinct
          if ActiveRecord::VERSION::MAJOR < 5
            scope = scope.uniq
          else
            scope = scope.distinct
          end
        end
        scope.pluck(qualified_column_name)
      else # Rails 2
        select = distinct ? "DISTINCT #{qualified_column_name}" : qualified_column_name
        query = scoped(find_options.merge(:select => select)).to_sql
        raw_values = connection.select_values(query)
        column = columns_hash[column_name.to_s] or raise "Could not retrieve column information: #{column_name}"
        raw_values.collect { |value| column.type_cast(value) }
      end
    end

    ActiveRecord::Base.extend(self)

  end
end
