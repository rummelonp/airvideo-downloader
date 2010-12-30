class Video < ActiveRecord::Base

  def self.parse(url)
    video = self.new
    video.url = url
    video
  end

  def self.recent
    find(:all,
         conditions: ['downloaded = ? and encoded = ?', true, true],
         order: 'id desc',
         limit: 10)
  end

end
