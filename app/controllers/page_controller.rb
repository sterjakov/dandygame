class PageController < ApplicationController

  layout 'front'

  def error_404
    render :status => 404

    # SEO
    @meta_title       = "Ошибка 404"
  end

  def privacy

  end

  def spasibo

  end

  def pulse

  end

  def pulse_new
    @comment  = Comment.new()
    @comments = Comment.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 100)
  end



end
