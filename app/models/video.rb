class Video < ActiveRecord::Base

  def self.parse(url)
    downloader = Downloader.parse url
    video = self.new
    video.url = downloader.url
    video.title = downloader.title
    video.video_url = downloader.video_url
    video
  end

  def self.recent
    find(:all,
         conditions: ['downloaded = ? and encoded = ?', true, true],
         order: 'id desc',
         limit: 10)
  end

end
