class Shogun::PagesController < ApplicationController
  def show
    hash = Shogun::RouteService.instance[request.fullpath.split('?').first.downcase]
    not_found! unless hash.present?
    if I18n.locale.present? && hash["languages"].any? && hash["languages"].include?(I18n.locale.to_s)
      @html = Shogun::RouteService.instance.html(hash["uuid"], I18n.locale.to_s)
    else
      @html = Shogun::RouteService.instance.html(hash["uuid"])
    end
    not_found! unless @html.present?
    render layout: Shogun.layout
  end

  private

  def not_found!
    raise ActionController::RoutingError.new('Not Found')
  end
end
