require 'simplecov'

module SimpleCov::Configuration
  def clean_filters
    @filters = []
  end
end

SimpleCov.configure do
  clean_filters
  load_adapter 'test_frameworks'
end

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'frozen_gems'
require 'frozen_gems/constants'
require 'fileutils'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
TEST_GEMFILE = 'Gemfile_test'

RSpec.configure do |config|
  config.before :each do
    @gemfile = File.expand_path(File.join(File.dirname(__FILE__), TEST_GEMFILE))
    FileUtils.cp(File.join(File.dirname(__FILE__), 'fixtures', GEMFILE), @gemfile)
  end

  config.after :each do
    FileUtils.rm(@gemfile)
  end
end
