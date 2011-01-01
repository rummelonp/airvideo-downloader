# -*- coding: utf-8 -*-

module Downloader
  class Base
    class << self
      attr_accessor :video_dir
      attr_reader :host
      alias_method :parsers, :subclasses

      def parse(url)
        instance = self.new
        # do something
        instance
      end
    end

    attr_accessor :url
    attr_accessor :body
    attr_accessor :title
    attr_accessor :video_url
    attr_accessor :downloaded

    def initialize
      @downloaded = false
    end

    def download(download_path)
      Downloader.download(@video_url, download_path)
      @downloaded = true
    end
  end
end
