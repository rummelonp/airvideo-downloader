class IndexController < ApplicationController
  def status
    @videos = Video.recent
  end

  def parse
    unless url = params.delete(:url)
      flash[:notice] = 'Please specify the url.'
      return redirect_to :status
    end

    @video = Video.find_by_url(url) || Video.parse(url)
  end

  def download
  end

end
