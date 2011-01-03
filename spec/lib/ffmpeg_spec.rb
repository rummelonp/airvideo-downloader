require 'spec_helper'
require 'tempfile'

describe Ffmpeg do

  describe :encode do
    before do
      @encoded_file = Tempfile.new('test_video - airvideo.m4v')
      Ffmpeg.stub(:encode).and_return(nil)
    end

    it 'file should be exists' do
      File.should be_exists @encoded_file
    end
  end

end
