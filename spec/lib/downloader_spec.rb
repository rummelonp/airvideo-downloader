require 'spec_helper'
require 'tempfile'

describe Downloader do

  describe 'parse "http://example.com/youtube_video_url"' do
    before do
      Downloader.stub(:parse).and_return(Downloader::YouTube.new)
    end
    subject { Downloader.parse 'http://example.com/youtube_video_url' }
    it { should be_instance_of(Downloader::YouTube) }
  end

  describe :download do
    before do
      @download_file = Tempfile.new('test_video.flv')
      @download_path = @download_file.path
      Downloader.stub(:download).and_return(@download_file)
    end
    describe :download_path do
      subject { Downloader.download('http://example.com/video_url', @download_path) }
      it { subject.path.should == @download_path }
    end
    describe :file do
      subject { File }
      it { should be_exists @download_file }
    end
  end
  
end
