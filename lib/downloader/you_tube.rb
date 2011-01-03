# -*- coding: utf-8 -*-

module Downloader
  # YouTube parser
  class YouTube < Base
    @host = 'www.youtube.com'

    def self.parse(url)
      instance = super
      instance.title = instance.title.split(' ')[2..-1].join(' ')
      url_map = instance.body.match(/fmt_url_map=([^&]+&)/).to_a.last
      instance.video_url = URI.decode(url_map).
        split(',').map{|d| d.split('|').last}.first
      instance
    end
  end
end
