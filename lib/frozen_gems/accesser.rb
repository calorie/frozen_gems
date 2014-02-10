module Accesser
  module_function

  def get_tmpfile_path
    File.expand_path('Gemfile_for_frozen_gems')
  end
end
