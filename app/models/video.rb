class Video < ActiveRecord::Base
  VIDEO_DIR     = '/var/media/movie'
  ENCODE_SUFFIX = ' - airvideo'
  ENCODE_EXT    = '.m4v'

  validates_uniqueness_of :url
  validates_presence_of :url
  validates_presence_of :title
  validates_presence_of :video_url
  validates_presence_of :download_path
  validates_presence_of :encoded_path

  def download
    return true if self.downloaded?
    Downloader.download(self.video_url, self.download_path)
    self.downloaded = true
    self.save!
  end

  def encode
    return true if not self.downloaded? or self.encoded?
    Ffmpeg.encode(self.download_path, self.encoded_path)
    self.encoded = true
    self.save!
  end

  def proccess
    download
    encode
  end

  handle_asynchronously :proccess

  class << self
    def parse(url)
      downloader = Downloader.parse url
      video = self.new
      video.url = downloader.url
      video.title = downloader.title
      video.video_url = downloader.video_url
      video.download_path =
        File.join VIDEO_DIR, download_filename(video.title, video.video_url)
      video.encoded_path =
        File.join VIDEO_DIR, encoded_filename(video.title, video.video_url)
      video
    end

    def recent
      find(:all,
           conditions: ['downloaded = ? and encoded = ?', true, true],
           order: 'id desc',
           limit: 10)
    end

    def filename(title)
      title.split(' ').map(&:downcase).join('_')
    end

    def extname(video_url)
      File.extname(video_url).split(%r{[?&]}).first
    end

    def download_filename(title, video_url)
      "#{filename(title)}#{extname(video_url)}"
    end

    def encoded_filename(title, video_url)
      "#{filename(title)}#{ENCODE_SUFFIX}#{ENCODE_EXT}"
    end
  end
end
