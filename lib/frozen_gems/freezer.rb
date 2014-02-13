require 'fileutils'

class Freezer

  def initialize(gemfile_path)
    @gemfile_path = gemfile_path
    @tmpfile_path = tmpfile_path
  end

  def overwrite_gemfile
    cp_gemfile
    overwrite
    replace_gemfile
  end

  def overwrite
    return unless gemfile? && tmpfile?
    gemfile = File.open(@gemfile_path)
    tmpfile = File.open(@tmpfile_path, 'w')
    regex = /^\s*gem ['"]([-\w]+)['"](,.*)?/
    gems_hash = Parser.new(@gemfile_path).unfrozen_gems_hash

    gemfile.each do |line|
      name = line.scan(regex).flatten.first
      if !name.nil? && !gems_hash[name].nil?
        line.chomp! << ", '#{gems_hash[name]}'\n"
      end
      tmpfile.write(line)
    end

    gemfile.close
    tmpfile.close
  end

  def tmpfile_path
    File.join(File.dirname(@gemfile_path), 'Gemfile_for_frozen_gems')
  end

  def cp_gemfile
    return unless gemfile?
    FileUtils.cp(@gemfile_path, @tmpfile_path)
  end

  def replace_gemfile
    if gemfile? && tmpfile?
      FileUtils.rm_f(@gemfile_path)
      FileUtils.mv(@tmpfile_path, @gemfile_path)
    end
  end
end
