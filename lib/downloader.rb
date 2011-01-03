# -*- coding: utf-8 -*-

require 'open-uri'
require 'uri'
require 'shellwords'

Dir[Rails.root.join("lib/downloader/*.rb")].each {|f| require f}

# Wrapper for video downloads
module Downloader
  extend self

  # When you use the delayed jobs is that Delayed::Worker.Logger to
  # Otherwise the RAILS_DEFAULT_LOGGER
  LOGGER = Delayed::Worker.logger || RAILS_DEFAULT_LOGGER

  # Parsing from video url and returned downloader wrapper
  # Param:: (String) video url
  # Return:: Downloader::Base subclass instance
  # Raise:: Downloader::ParserError:
  #         raised when not implements parser
  def parse(url)
    host = URI.parse(url).host
    parser = Base.parsers.find {|p| p.host === host} or
      raise ParserError.new 'not implements parser.'
    parser.parse(url)
  end

  # Downloading from video url and download path
  # Param:: (String) video url,
  #         (String) download path
  # Return:: nil
  def download(video_url, download_path)
    LOGGER.info `wget -O #{download_path.shellescape} '#{video_url}' 2>&1`
  end
end
