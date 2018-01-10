require "http_accept_language"

class Shogun::PagesController < Shogun::ApplicationController
  def show
    hash = Shogun::RouteService.instance[request.fullpath.split('?').first.downcase]
    not_found! unless hash.present?
    @html = get_html(hash)
    not_found! unless @html.present?
    @shogun_meta_tags = hash["meta_tags"]
    render layout: (hash["layout"] || Shogun.layout)
  end

  private

  def get_html(hash)
    return Shogun::RouteService.instance.html(uuid) if hash.is_a?(String)

    languages = hash["languages"]
    uuid = hash["uuid"]
    return Shogun::RouteService.instance.html(uuid) unless languages.any?

    if languages.include?(params[:locale].to_s)
      return Shogun::RouteService.instance.html(uuid, params[:locale].to_s)
    end

    pl = http_accept_language.user_preferred_languages

    pl.each do |lang|
      if languages.include?(lang)
        return Shogun::RouteService.instance.html(uuid, lang)
      end
    end

    if languages.include?(I18n.locale.to_s)
      return Shogun::RouteService.instance.html(uuid, I18n.locale.to_s)
    end

    Shogun::RouteService.instance.html(uuid)
  end

  def http_accept_language
    HttpAcceptLanguage::Parser.new(request.env["HTTP_ACCEPT_LANGUAGE"])
  end
end
