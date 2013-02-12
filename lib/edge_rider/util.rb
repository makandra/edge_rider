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

    def exclusive_query(model, conditions)
      if Rails.version < '3'
        model.send(:with_exclusive_scope) do
          model.scoped(:conditions => conditions)
        end
      else
        model.unscoped.where(conditions)
      end
    end

    def scope?(object)
      object.respond_to?(:scoped)
    end

  end
end
