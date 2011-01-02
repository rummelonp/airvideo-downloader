require 'spec_helper'

describe Downloader do

  describe 'parse "http://example.com/youtube_video_url"' do
    before do
      Downloader.stub(:parse).and_return(Downloader::YouTube.new)
    end
    subject { Downloader.parse 'http://example.com/youtube_video_url' }
    it { should be_instance_of(Downloader::YouTube) }
  end
  
end
