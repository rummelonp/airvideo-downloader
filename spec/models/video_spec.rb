require 'spec_helper'

describe Video do

  describe :parse do
    subject { Video.parse('http://example.com/video_url') }
    it { should be_instance_of(Video) }
  end

end
