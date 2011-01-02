# -*- coding: utf-8 -*-

require 'open-uri'
require 'uri'
require 'shellwords'

Dir[Rails.root.join("lib/downloader/*.rb")].each {|f| require f}

module Downloader
  extend self

  def parse(url)
    host = URI.parse(url).host
    parser = Base.parsers.find {|p| p.host === host} or
      raise ParserError.new 'not implements parser.'
    parser.parse(url)
  end

  def download(video_url, download_path)
    `wget -O #{download_path.shellescape} '#{video_url}' 2>&1`
  end
end
