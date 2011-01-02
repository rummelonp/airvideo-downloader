class IndexController < ApplicationController
  def status
    @videos = Video.recent
  end

  def parse
    url = params.delete(:url)
    begin
      @video = Video.find_by_url(url) || Video.parse(url)
    rescue => e
      logger.info e
      flash[:notice] = 'Please specify the url.'
      redirect_to :status
    end
  end

  def download
    @video = Video.new params.delete(:video)
    begin
      raise unless @video.valid?
      flash[:notice] = 'Downloading and encoding.'
      redirect_to :status
    rescue => e
      logger.info e
      flash[:notice] = 'Some errors occured.'
      redirect_to :status
    end
  end

end
