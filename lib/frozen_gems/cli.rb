require 'thor'

class Cli < Thor
  include Thor::Actions

  default_task :gems

  desc 'gems [GEMFILE_PATH]',
       "Write installed gems' versions to Gemfile"
  def gems(gemfile_path = 'Gemfile')
    gemfile_path = File.expand_path(gemfile_path)
    Freezer.new(gemfile_path).overwrite_gemfile
  end
end
