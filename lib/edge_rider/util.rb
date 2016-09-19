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
      if activerecord2?
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
    
    def define_scope(klass, name, lambda)
      if ActiveRecord::VERSION::MAJOR < 4 # Rails 2/3
        scope_definition = ActiveRecord::VERSION::MAJOR < 3 ? :named_scope : :scope
        klass.send scope_definition, name, lambda
      else
        klass.send :scope, name, lambda { |*args|
          options = lambda.call(*args)
          klass.scoped(options.slice :conditions)
        }
      end      
    end
    
    def define_association(owner, association, target, options)
      if active_record_version < 4
        owner.send association, target, options
      else
        # Reduce the options hash to the given keys and store the remainder in
        # other_options. Using Hash#extract! would be easier to unterstand,
        # but Rails 2 does not have it.
        other_options = options.slice!(:conditions)
        scope = lambda { |*args| scoped(options) }
        owner.send association, target, scope, other_options
      end
    end

    def active_record_version
      ActiveRecord::VERSION::MAJOR
    end

    def activerecord2?
      active_record_version < 3
    end

    def rspec_version
      if defined?(Spec)
        1
      else
        require 'rspec/version'
        RSpec::Version::STRING.to_i
      end
    end

    def rspec_root
      if rspec_version == 1
        Spec
      else
        RSpec
      end
    end

    def rspec_path
      if rspec_version == 1
        'spec'
      else
        'rspec'
      end
    end

  end
end
