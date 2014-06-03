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
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
