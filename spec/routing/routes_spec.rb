require 'spec_helper'

describe :routes do

  describe 'GET "/"' do
    subject { {get: '/'} }
    it { should route_to(controller: 'index', action: 'status') }
  end

  describe 'GET "/parse"' do
    subject { {get: '/parse'} }
    it { should route_to(controller: 'index', action: 'parse') }
  end

  describe 'POST "/download"' do
    subject { {post: '/download'} }
    it { should route_to(controller: 'index', action: 'download') }
  end

end
