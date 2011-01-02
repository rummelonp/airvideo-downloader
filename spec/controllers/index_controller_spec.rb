require 'spec_helper'

describe IndexController do

  describe 'GET "/"' do
    context :response do
      before { get :status }
      subject { response }
      it { should be_success }
    end
  end

  describe 'GET "/parse"' do

    context 'widhout url' do
      before { get :parse }

      describe :response do
        subject { response }
        it { should be_redirect }
        describe :redirect_to do
          subject { URI.parse(response.redirect_url).request_uri }
          it { should == '/' }
        end
      end

      describe :flash, :notice do
        subject { request.session['flash'][:notice] }
        it { should == 'Please specify the url.' }
      end
    end

    context 'with url' do
      describe :response do
        before do
          Video.stub(:parse).and_return(Video.new)
          get :parse, url: 'http://example.com/video_url'
        end
        subject { response }
        it { should be_success }
      end
    end

  end

  describe 'POST "/download"' do

    context 'without parameters' do
      before { post :download }

      describe :response do
        subject { response }
        it { should be_redirect }
        describe :redirect_to do
          subject { URI.parse(response.redirect_url).request_uri }
          it { should == '/' }
        end
      end

      describe :flash, :notice do
        subject { request.session['flash'][:notice] }
        it { should == 'Some errors occured.' }
      end
    end

    context 'with video parameters' do
      before do
        post :download, video: {
          url: 'http://example.com/video_url',
          title: 'Test Title',
          video_url: 'http://example.com/video_url.flv',
          download_path: '/tmp/test_title.flv',
          encoded_path: '/tmp/test_title - airvideo.m4v'
        }
      end

      describe :response do
        subject { response }
        it { should be_redirect }
        describe :redirect_to do
          subject { URI.parse(response.redirect_url).request_uri }
          it { should == '/' }
        end
      end

      describe :flash, :notice do
        subject { request.session['flash'][:notice] }
        it { should == 'Downloading and encoding.' }
      end
    end

  end

end
