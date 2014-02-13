module Validator
  module_function

  def gemfile?
    File.exist?(@gemfile_path || 'Gemfile')
  end

  def tmpfile?
    File.exist?(@tmpfile_path || 'Gemfile_for_frozen_gems')
  end
end
