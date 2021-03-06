# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

# explicitly setup bundle before requiring environment so simplecov is available prior to loading environment
require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

# Require simplecov before loading ..dummy/config/environment.rb because it will cause metasploit-credential/lib to
# be loaded, which would result in Coverage not recording hits for any of the files.
require 'simplecov'
require 'coveralls'

if ENV['TRAVIS'] == 'true'
  # don't generate local report as it is inaccessible on travis-ci, which is why coveralls is being used.
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
else
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end

require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'

#
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories from this gem and metasploit-concern
#

rooteds = [
    Metasploit::Concern,
    Metasploit::Credential::Engine,
    Metasploit::Model::Engine,
    MetasploitDataModels::Engine
]

rooteds.each do |rooted|
  Dir[rooted.root.join('spec', 'support', '**', '*.rb')].each do |f|
    require f
  end
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
