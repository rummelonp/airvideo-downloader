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
        before { get :parse, url: 'http://example.com/video_url' }
        subject { response }
        it { should be_success }
      end
    end

  end

end