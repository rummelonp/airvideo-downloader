# -*- coding: utf-8 -*-

module Downloader
  # Base parser
  # When you make a parser for each site to extend this subclass
  class Base
    class << self
      attr_reader :host
      alias_method :parsers, :subclasses

      # Parsing from video url and returned download wrapper
      # Read body and pase title only
      # Param:: (String) video url
      # Return:: Downloader::Base subclass instance
      def parse(url)
        instance = self.new
        instance.url = url
        instance.body = open(url).read
        if instance.body.match(%r{<title>(.*?)</title>}m)
          instance.title = $1.to_s.strip.gsub(%r{[\n\r\t]}m, '')
        end
        instance
      end
    end

    attr_accessor :url
    attr_accessor :body
    attr_accessor :title
    attr_accessor :video_url
    attr_accessor :downloaded

    # Initializing
    # Set downloaded to false
    def initialize
      @downloaded = false
    end

    # Downloading from download path
    # Param:: (String) download path
    # Return:: true
    #          returns true if successful
    def download(download_path)
      Downloader.download(@video_url, download_path)
      @downloaded = true
    end
  end
end
