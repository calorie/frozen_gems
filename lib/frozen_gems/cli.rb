require 'thor'

class Cli < Thor
  include Thor::Actions

  default_task :gems

  desc 'gems [GEMFILE_PATH]',
       "Write installed gems' versions to Gemfile"
  def gems(gemfile = 'Gemfile')
    gemfile = File.expand_path(gemfile)
    abort "#{gemfile} is directory." if File.directory?(gemfile)
    Freezer.new(gemfile).overwrite_gemfile
  end
end
