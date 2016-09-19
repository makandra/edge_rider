$: << File.join(File.dirname(__FILE__), "/../lib" )

require 'edge_rider'
require 'edge_rider/development'
require 'database_cleaner'
require 'gemika'

# Requires supporting files with custom matchers and macros, etc in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/*.rb"].sort.each {|f| require f}

configurator = defined?(RSpec) ? RSpec : Spec::Runner
configurator.configure do |config|

  config.before(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end

  if Gemika::Env.rspec_2_plus?
    config.mock_with :rspec do |c|
      c.syntax = [:should, :expect]
    end

    config.expect_with :rspec do |c|
      c.syntax = [:should, :expect]
    end
  end

end
