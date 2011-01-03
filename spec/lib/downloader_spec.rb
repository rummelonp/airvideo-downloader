require 'spec_helper'
require 'tempfile'

describe Downloader do

  describe :parse do
    context 'http://example.com/youtube_video_url' do
      before do
        Downloader.stub(:parse).and_return(Downloader::YouTube.new)
      end

      subject { Downloader.parse 'http://example.com/youtube_video_url' }

      it { should be_instance_of(Downloader::YouTube) }
    end

    context 'http://example.com/xvideos_video_url' do
      before do
        Downloader.stub(:parse).and_return(Downloader::Xvideos.new)
      end

      subject { Downloader.parse 'http://example.com/xvideos_video_url' }

      it { should be_instance_of(Downloader::Xvideos) }
    end
  end

  describe :download do
    before do
      @video_url = 'http://example.com/video_url'
      @download_file = Tempfile.new('test_video.flv')
      @download_path = @download_file.path
      Downloader.stub(:download).and_return(nil)
      Downloader.download(@video_url, @download_path)
    end

    it 'file should be exists' do
      File.should be_exists @download_file
    end
  end
  
end
