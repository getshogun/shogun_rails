class Shogun::PagesController < ApplicationController
  def show
    @page = Shogun::RouteService.instance[request.fullpath.split('?').first.downcase]
    raise ActionController::RoutingError.new('Not Found') unless @page.present?
    @html = Shogun::RouteService.html(@page[:uuid])
    render layout: Shogun.layout
  end
end
