class SitemapController < ApplicationController

  def index

    @trainings = Training.order("updated_at desc").all

    render 'sitemap/index.xml', layout: false, content_type: 'application/xml'



  end

end
