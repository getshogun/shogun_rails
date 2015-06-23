class Shogun::PagesController < ApplicationController
  def show
    hash = Shogun::RouteService.instance[request.fullpath.split('?').first.downcase]
    not_found! unless hash.present?
    @html = get_html(hash)
    not_found! unless @html.present?
    render layout: Shogun.layout
  end

  private

  def get_html(hash)
    languages = hash["languages"]
    uuid = hash["uuid"]
    return Shogun::RouteService.instance.html(uuid) unless languages.any?

    if languages.include?(params[:locale].to_s)
      return Shogun::RouteService.instance.html(uuid, params[:locale].to_s)
    end

    if languages.include?(I18n.locale.to_s)
      return Shogun::RouteService.instance.html(uuid, I18n.locale.to_s)
    end

    Shogun::RouteService.instance.html(uuid)
  end

  def not_found!
    raise ActionController::RoutingError.new('Not Found')
  end
end
