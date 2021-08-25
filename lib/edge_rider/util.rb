# encoding: utf-8

module EdgeRider
  module Util
    extend self

    def qualify_column_name(model, column_name)
      column_name = column_name.to_s
      unless column_name.include?('.')
        column_name = if ActiveRecord::VERSION::MAJOR < 4
          quoted_table_name = model.connection.quote_table_name(model.table_name)
          quoted_column_name = model.connection.quote_column_name(column_name)
          "#{quoted_table_name}.#{quoted_column_name}"
        else
          # Rails 4+ will quote correctly and Rails 5.2 will print
          # deprecation warnings if there are surplus quotes
          "#{model.table_name}.#{column_name}"
        end
      end
      column_name
    end

    def exclusive_query(model, conditions)
      model.unscoped.where(conditions)
    end

    def scope?(object)
      object.respond_to?(:scoped)
    end
    
    def define_scope(klass, name, lambda)
      if ActiveRecord::VERSION::MAJOR == 3
        klass.send :scope, name, lambda
      else
        klass.send :scope, name, lambda { |*args|
          options = lambda.call(*args)
          if ActiveRecord::VERSION::MAJOR < 6
            klass.scoped(options.slice :conditions)
          else
            scoped(options.slice :conditions)
          end
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
        owner.send association, target, scope, **other_options
      end
    end

    def active_record_version
      ActiveRecord::VERSION::MAJOR
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
