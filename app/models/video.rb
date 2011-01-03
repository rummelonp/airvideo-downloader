class Video < ActiveRecord::Base
  # Video download and encode directory
  VIDEO_DIR     = '/var/media/movie'
  # Encoded video file suffix
  ENCODE_SUFFIX = ' - airvideo'
  # Encoded video file ext
  ENCODE_EXT    = '.m4v'

  validates_uniqueness_of :url
  validates_presence_of :url
  validates_presence_of :title
  validates_presence_of :video_url
  validates_presence_of :download_path
  validates_presence_of :encoded_path

  # Downloading video
  # Set downloaded to true and saved when download successful
  def download
    return true if self.downloaded?
    Downloader.download(self.video_url, self.download_path)
    self.downloaded = true
    self.save!
  end

  # Encoding video
  # Set encoded to true and saved when encode successfull
  def encode
    return true if not self.downloaded? or self.encoded?
    Ffmpeg.encode(self.download_path, self.encoded_path)
    self.encoded = true
    self.save!
  end

  # Downloading and encoding in delayed jobs
  def proccess
    download
    encode
  end

  handle_asynchronously :proccess

  class << self
    # Parsing from url
    # And make download path and encoded path
    # Param:: (String) url
    # Return:: (Video) video instance not saved
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

    # Find recent downloaded and encoded videos
    def recent
      find(:all,
           conditions: ['downloaded = ? and encoded = ?', true, true],
           order: 'id desc',
           limit: 10)
    end

    # Make filename from tile
    def filename(title)
      title.split(' ').map(&:downcase).join('_')
    end

    # Make extname from video url
    def extname(video_url)
      File.extname(video_url).split(%r{[?&]}).first
    end

    # Make download filename from title and video url
    def download_filename(title, video_url)
      "#{filename(title)}#{extname(video_url)}"
    end

    # Make encoded filename from title and video url
    def encoded_filename(title, video_url)
      "#{filename(title)}#{ENCODE_SUFFIX}#{ENCODE_EXT}"
    end
  end
end
