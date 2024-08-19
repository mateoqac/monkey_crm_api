# Make sure to require this file in your rails_helper.rb
require 'database_cleaner/active_record'

RSpec.configure do |config|
  # Use DatabaseCleaner to clean the database between test runs
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
