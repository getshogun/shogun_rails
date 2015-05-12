class Shogun::PagesController < ApplicationController
  def show
    uuid = Shogun::RouteService.instance[request.fullpath.split('?').first.downcase]
    not_found! unless uuid.present?
    @html = Shogun::RouteService.instance.html(uuid)
    not_found! unless @html.present?
    render layout: Shogun.layout
  end

  private

  def not_found!
    raise ActionController::RoutingError.new('Not Found')
  end
end
