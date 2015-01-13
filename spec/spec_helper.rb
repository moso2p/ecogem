gem 'bundler', "= #{ENV['ECOGEM_TEST_BUNDLER_VERSION']}"
require 'ecogem'

RSpec.configure do |c|
  c.disable_monkey_patching!
  c.fail_fast = true
end