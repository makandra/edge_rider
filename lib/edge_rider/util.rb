# encoding: utf-8

module EdgeRider
  module Util
    extend self

    def qualify_column_name(model, column_name)
      column_name = column_name.to_s
      column_name = "#{model.table_name}.#{column_name}" unless column_name.include?('.')
      column_name
    end

    def exclusive_query(model, conditions)
      model.unscoped.where(conditions)
    end

    def scope?(object)
      object.respond_to?(:scoped)
    end

    def define_scope(klass, name, lambda)
      klass.send :scope, name, lambda { |*args|
        options = lambda.call(*args)
        scoped(options.slice :conditions) 
      }
    end

    def define_association(owner, association, target, options)
      conditions = options.extract!(:conditions)
      scope = lambda { |*args| scoped(conditions) }
      owner.send association, target, scope, **options
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
