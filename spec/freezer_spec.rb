require 'spec_helper'

describe 'Freezer' do
  let(:gemfile) { @gemfile }
  let(:freezer) { Freezer.new(gemfile) }

  describe 'overwrite_gemfile' do
    before do
      freezer.overwrite_gemfile
    end

    it 'overwrite Gemfile' do
    end
  end
end
