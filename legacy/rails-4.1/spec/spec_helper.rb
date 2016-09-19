$: << File.join(File.dirname(__FILE__), "/../../lib" )

ENV['RAILS_ENV'] ||= 'test'
ENV['RAILS_ROOT'] = 'app_root'

FileUtils.rm(Dir.glob("app_root/db/*.db"), :force => true)

# Load the Rails environment and testing framework
require "#{File.dirname(__FILE__)}/../app_root/config/environment"
require 'rspec/rails'
require 'edge_rider/development'
DatabaseCleaner.strategy = :truncation

require 'rspec_candy/helpers'

# Run the migrations
EdgeRider::Development.migrate_test_database

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.use_instantiated_fixtures  = false
  config.before(:each) do
    DatabaseCleaner.clean
  end
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end




# encoding: utf-8

$: << File.join(File.dirname(__FILE__), "/../../lib" )

ENV['RAILS_ENV'] = 'test'

# Load the Rails environment and testing framework
require "#{File.dirname(__FILE__)}/../app_root/config/environment"
require "#{EdgeRider::Util.rspec_path}/rails"
require 'edge_rider/development'
DatabaseCleaner.strategy = :truncation

# Requires supporting files with custom matchers and macros, etc in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|

  config.use_transactional_fixtures = false
  config.use_instantiated_fixtures  = false

  config.before(:each) do
    DatabaseCleaner.clean
  end

  if EdgeRider::Util.rspec_version >= 2
    config.mock_with :rspec do |c|
      c.syntax = [:should, :expect]
    end

    config.expect_with :rspec do |c|
      c.syntax = [:should, :expect]
    end
  end

end
