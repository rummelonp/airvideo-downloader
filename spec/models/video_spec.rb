require 'spec_helper'

describe Video do

  describe :parse do
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

end
