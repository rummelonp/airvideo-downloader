require 'spec_helper'

describe Video do

  describe :parse do
    before { Video.stub(:parse).and_return(Video.new) }
    subject { Video.parse('http://example.com/video_url') }
    it { should be_instance_of(Video) }
  end

  describe :recent do
    before do
      Video.stub(:recent).and_return([Video.new] * 10)
      @recent = Video.recent
    end
    describe do
      subject { @recent }
      it { should have_at_most(10).items }
    end
    describe do
      subject { @recent.first }
      it { should be_instance_of(Video) }
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
