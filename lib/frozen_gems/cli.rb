require 'thor'
require 'fileutils'

class Cli < Thor
  include Thor::Actions

  GEMFILE_TMP = 'Gemfile_tmp'

  default_task :gems

  desc 'gems [GEMFILE_PATH]',
       "Write installed gems' versions to Gemfile"
  def gems(gemfile = 'Gemfile')
    gemfile = File.expand_path(gemfile)

    Dir.chdir(File.dirname(gemfile)) do
      FileUtils.cp(gemfile, GEMFILE_TMP)
      overwrite_gemfile(gemfile)
      FileUtils.rm_f(GEMFILE_TMP)
    end
  end

  private

  def overwrite_gemfile(gemfile)
    regex = /^\s*gem ['"]([-\w]+)['"](,.*)?/
    gems_hash = unfrozen_gems_hash

    file = File.open(gemfile, 'w')
    File.open(GEMFILE_TMP) do |tmp|
      tmp.each do |line|
        name = line.scan(regex).flatten.first
        if !name.nil? && !gems_hash[name].nil?
          line.chomp! << ", '#{gems_hash[name]}'\n"
        end
        file.write(line)
      end
    end
  end

  def unfrozen_gems_hash
    hash = {}
    gems = unfrozen_gems
    regex = /(\w+(\-\w+)*)\s+\((\d+\.\d+\.\d+(\.\d+)*)\)/m
    gems_info = `bundle exec gem list`.scan(regex)
    gems_info.each do |info|
      info.compact!
      name, version = info.first, info.last
      hash[name] = version if gems.include?(name)
    end
    hash
  end

  def unfrozen_gems
    regex = /^\s*gem ['"]([-\w]+)['"](,.*)?/
    gems = File.read(GEMFILE_TMP).scan(regex).map do |g|
      g.first if g.last.nil?
    end
    gems.compact
  end
end
