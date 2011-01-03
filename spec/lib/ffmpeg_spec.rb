require 'spec_helper'
require 'tempfile'

describe Ffmpeg do

  describe :encode do
    before do
      @download_file = Tempfile.new('test_video.flv')
      @encoded_file = Tempfile.new('test_video - airvideo.m4v')
      @download_path = @download_file.path
      @encoded_path = @encoded_file.path
      Ffmpeg.stub(:encode).and_return(nil)
      Ffmpeg.encode(@download_path, @encoded_path)
    end

    it 'file should be exists' do
      File.should be_exists @encoded_file
    end
  end

end
