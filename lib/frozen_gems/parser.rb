class Parser
  def initialize(gemfile_path)
    @gemfile_path = gemfile_path
  end

  def unfrozen_gems_hash
    return {} unless gemfile?
    hash = {}
    gems = unfrozen_gems
    regex = /(\w+(\-\w+)*)\s+\((\d+\.\d+\.\d+(\.\d+)*)\)/m
    gems_info = Dir.chdir(File.dirname(@gemfile_path)) do
      `bundle exec gem list`.scan(regex)
    end
    gems_info.each do |info|
      info.compact!
      name, version = info.first, info.last
      hash[name] = version if gems.include?(name)
    end
    hash
  end

  def unfrozen_gems
    return [] unless gemfile?
    regex = /^\s*gem ['"]([-\w]+)['"](,.*)?/
    gems = File.read(@gemfile_path).scan(regex).map do |g|
      g.first if g.last.nil?
    end
    gems.compact
  end
end
