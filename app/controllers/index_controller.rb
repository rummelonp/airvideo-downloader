class IndexController < ApplicationController
  def status
  end

  def parse
    unless params[:url]
      flash[:notice] = 'Please specify the url.'
      return redirect_to :status
    end
  end

  def download
  end

end
