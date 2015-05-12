class Shogun::PagesController < ApplicationController
  def show
    @page = Shogun::RouteService.instance[request.fullpath.split('?').first.downcase]
    raise ActionController::RoutingError.new('Not Found') unless @page.present?
    render layout: Shogun.layout
  end
end
