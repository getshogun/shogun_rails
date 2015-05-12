class Shogun::PagesController < ApplicationController
  def show
    @page = Shogun::RouteService[request.fullpath.split("?")[0]]
    render layout: Shogun.layout
  end
end
