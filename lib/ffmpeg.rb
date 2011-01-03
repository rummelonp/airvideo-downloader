# -*- coding: utf-8 -*-

require 'shellwords'
require 'active_support/core_ext/string/inflections'

# Wrapper for ffmpeg encoding
class Ffmpeg
  # When you use the delayed jobs is that Delayed::Worker.Logger to
  # Otherwise the RAILS_DEFAULT_LOGGER
  LOGGER = Delayed::Worker.logger || RAILS_DEFAULT_LOGGER

  # Default encode optiosn
  DEFAULT = {
    size: '640x480',
    framerate: '25',
    bitrate: '1200',
    audiosamplerate: '48000',
    audiodatarate: '128',
  }

  class << self
    # Encoding from input file path and output file path
    # Param:: (String) input file path,
    #         (String) output file path
    # Return:: nil
    def encode(input, output)
      self.new(input).encode(output)
    end

    # Parsing metadata from ffmpeg infomation output
    # Param:: (String) ffmpeg infomation output
    # Return:: (Hash) parsed metadata
    def metadata(output)
      metadata = {}
      lines = output.split(/\n/)
      lines.grep(/ {4}.+: .+/).
        map {|l| l.split(':').map(&:strip)}.
        select {|a| a.size == 2}.
        each {|d| metadata[d.first.underscore.to_sym] = d.last}
      metadata
    end

    # Parsing data from ffmpeg infomation output
    # Param:: (String) ffmpeg infomation output
    # Return:: (Hash) parsed data
    def data(output)
      data = {}
      lines = output.split(/\n/)
      lines.grep(/Duration:/).first.split(/,/).
        map {|l| l.split(': ').map(&:strip)}.
        each {|d| data[d.first.underscore.to_sym] = d.last}
      data[:size] = $1 if lines.grep(/Video:/).first.match(/(\d+x\d+)/)
      data
    end
  end

  attr_reader :path, :output, :metadata, :data

  # Initializing ffmpeg wrapper instance from input file path
  # Pasing metadata and data
  # Param:: (String) input file path
  # Return:: Ffmpeg instance
  def initialize(path)
    @path = path
    @output = %x{ffmpeg -i #{@path.shellescape} 2>&1}
    @metadata = self.class.metadata(@output)
    @data = self.class.data(@output)
  end

  # Encoding from output file path
  # Param:: (String) output file path
  # Return:: nil
  def encode(path)
    exec    = "ffmpeg"
    input   = "-i #{@path.shellescape}"
    vcodec  = "-vcodec mpeg4"
    vsize   = "-s #{@data[:size] or DEFAULT[:size]}"
    vrate   = "-r #{@metadata[:framerate] or DEFAULT[:framerate]}"
    vbit    = "-b #{@data[:bitrate].split(' ').first or DEFAULT[:bitrate]}k"
    acodec  = "-acodec libfaac"
    achan   = "-ac 2"
    arate   = "-ar #{@metadata[:audiosamplerate] or DEFAULT[:audiosamplerate]}"
    abit    = "-ab #{@metadata[:audiodatarate] or DEFAULT[:audiodatarate]}k"
    output  = "#{path.shellescape} 2>&1"
    command = [exec, input,
               vcodec, vsize, vrate, vbit,
               acodec, achan, arate, abit,
               output].join(' ')
    LOGGER.info self
    LOGGER.info DEFAULT
    LOGGER.info command
    LOGGER.info `#{command}`
  end

end
