require 'fileutils'

class Freezer
  def initialize(gemfile_path)
    @gemfile_path = gemfile_path
  end

  def overwrite_gemfile
    Dir.chdir(File.dirname(@gemfile_path)) do
      tmpfile_path = get_tmpfile_path
      FileUtils.cp(@gemfile_path, tmpfile_path)

      overwrite

      FileUtils.rm_f(@gemfile_path)
      FileUtils.mv(tmpfile_path, @gemfile_path)
    end
  end

  def overwrite
    tmpfile_path = get_tmpfile_path
    gemfile = File.open(@gemfile_path)
    tmpfile = File.open(tmpfile_path, 'w')
    regex = /^\s*gem ['"]([-\w]+)['"](,.*)?/
    gems_hash = unfrozen_gems_hash

    gemfile.each do |line|
      name = line.scan(regex).flatten.first
      if !name.nil? && !gems_hash[name].nil?
        line.chomp! << ", '#{gems_hash[name]}'\n"
      end
      tmpfile.write(line)
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
    gems = File.read(@gemfile_path).scan(regex).map do |g|
      g.first if g.last.nil?
    end
    gems.compact
  end

  def get_tmpfile_path
    Dir.chdir(File.dirname(@gemfile_path)) do
      File.expand_path('Gemfile_for_frozen_gems')
    end
  end
end
