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
      Downloader.stub(:download).and_return(nil)
      Ffmpeg.stub(:encode).and_return(nil)
      @video = Video.new @valid_data
      @video.download
      @video.encode
    end

    subject { @video }

    it 'downloaded should be true' do
      subject.downloaded.should be_true
    end

    it 'encoded should be true' do
      subject.encoded.should be_true
    end
  end

  describe 'parse "http://example.com/video_url"' do
    before { Video.stub(:parse).and_return(Video.new) }

    subject { Video.parse('http://example.com/video_url') }

    it 'should be instance of Video' do
      should be_instance_of(Video)
    end
  end

  describe :recent do
    before do
      @video = Video.new
      @video.downloaded = true
      @video.encoded = true
      Video.stub(:recent).and_return([@video] * 10)
      @recent = Video.recent
    end

    subject { @recent }

    it { should have_at_most(10).items }

    describe :first do
      subject { @recent.first }

      it 'should be instance of Video' do
        should be_instance_of(Video)
      end

      it 'downloaded should be true' do
        subject.downloaded.should be_true
      end

      it 'encoded should be true' do
        subject.encoded.should be_true
      end
    end
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
