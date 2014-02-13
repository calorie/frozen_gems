module Validator
  module_function

  def gemfile?
    File.exist?(@gemfile_path || GEMFILE)
  end

  def tmpfile?
    File.exist?(@tmpfile_path || TMPFILE)
  end
end
