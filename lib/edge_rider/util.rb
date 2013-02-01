# encoding: utf-8

module EdgeRider
  module Util
    extend self

    def qualify_column_name(model, column_name)
      column_name = column_name.to_s
      unless column_name.include?('.')
        quoted_table_name = model.connection.quote_table_name(model.table_name)
        quoted_column_name = model.connection.quote_column_name(column_name)
        column_name = "#{quoted_table_name}.#{quoted_column_name}"
      end
      column_name
    end

    #def scope_to_sql(options = {})
    #  if Rails.version < '3'
    #    scope.construct_finder_sql(options)
    #  else
    #    scope.scoped(options).to_sql
    #  end
    #end

    def append_scope_conditions(scope, conditions)
      if scope.respond_to?(:where)
        # Rails 3
        scope.where(conditions)
      else
        # Rails 2
        scope.scoped(:conditions => conditions)
      end
    end

  end
end
