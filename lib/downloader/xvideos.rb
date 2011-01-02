# -*- coding: utf-8 -*-

module Downloader
  class Xvideos < Base
    @host = 'www.xvideos.com'

    def self.parse(url)
      instance = super
      instance.title = instance.title.split(' ')[0..-3].join(' ')
      url = instance.body.match(%r{flv_url=([^&]+)&}).to_a.last
      instance.video_url = URI.decode(url)
      instance
    end
  end
end
