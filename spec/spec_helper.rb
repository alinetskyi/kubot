require "bundler/setup"
require "kubot"
require "rspec"
require "net/http"
require 'timeout'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  config.color_mode = true
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.full_backtrace = true 
  #config.expect_with :rspec do |c|
  #  c.syntax = :expect
  #end
end
