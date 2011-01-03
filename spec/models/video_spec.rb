require 'spec_helper'

describe Video do

  before do
    @valid_data = {
      url: 'http://example.com/video_url',
      title: 'Test Title',
      video_url: 'http://example.com/video_url.flv',
      download_path: '/var/media/movie/test_title.flv',
      encoded_path: '/var/media/movie/test_title - airvideo.m4v'
    }
    @invalid_data = @valid_data.merge url: nil
  end

  describe :validates do
    context 'presence all' do
      subject { Video.new @valid_data }
      it { should be_valid }
    end
    context 'presence without url' do
      subject { Video.new @invalid_data }
      it { should_not be_valid }
    end
  end

  describe :proccess do
    before do
      @video = Video.new @valid_data
      Downloader.stub(:download).and_return(nil)
      Ffmpeg.stub(:encode).and_return(nil)
    end
    describe :download, :downloaded do
      before { @video.download }
      subject { @video.downloaded }
      it { should be_true }
    end
    describe :encode, :encoded do
      before do
        @video.downloaded = true
        @video.encode
      end
      subject { @video.encoded }
      it { should be_true }
    end
  end

  describe 'parse "http://example.com/video_url"' do
    before { Video.stub(:parse).and_return(Video.new) }
    subject { Video.parse('http://example.com/video_url') }
    it { should be_instance_of(Video) }
  end

  describe :recent do
    before do
      Video.stub(:recent).and_return([Video.new] * 10)
      @recent = Video.recent
    end
    subject { @recent }
    it { should have_at_most(10).items }
    it { subject.first.should be_instance_of(Video) }
  end

  describe 'title "Test Title" and video_url "http://example.com/video_url.flv"' do
    before do
      @title = 'Test Title'
      @video_url = 'http://example.com/video_url.flv'
    end
    describe :filename do
      subject { Video.filename @title }
      it { should == 'test_title' }
    end
    describe :extname do
      subject { Video.extname @video_url }
      it { should == '.flv' }
    end
    describe :download_filename do
      subject { Video.download_filename @title, @video_url }
      it { should == 'test_title.flv' }
    end
    describe :encoded_filename do
      subject { Video.encoded_filename @title, @video_url }
      it { should == 'test_title - airvideo.m4v' }
    end
  end

end
