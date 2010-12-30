class Video < ActiveRecord::Base

  def self.parse(url)
    video = self.new
    video.url = url
    video
  end

end
