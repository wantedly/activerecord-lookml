require "bundler/setup"
require "active_record"
require "active_record/lookml"

DB_CONFIG = {
  adapter: 'postgresql',
  host: 'localhost',
  username: 'postgres',
  min_messages: 'ERROR',
}.with_indifferent_access.freeze

ActiveRecord::Base.establish_connection(DB_CONFIG)
load "#{File.dirname(__FILE__)}/schema.rb"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
