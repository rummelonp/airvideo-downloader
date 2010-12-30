require 'spec_helper'

describe Video do

  describe :parse do
    subject { Video.parse('http://example.com/video_url') }
    it { should be_instance_of(Video) }
  end

  describe :recent do
    before { @recent = Video.recent }
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
