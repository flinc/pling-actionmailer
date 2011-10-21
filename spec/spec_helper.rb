require 'rubygems'
require 'bundler'

Bundler.require

require 'pling/gateway/action_mailer'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActionMailer::Base.delivery_method = :test

RSpec.configure do |config|
  config.mock_with :rspec
end
