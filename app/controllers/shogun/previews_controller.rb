require "http"

class Shogun::PreviewsController < Shogun::ApplicationController
  def show
    not_found! unless Shogun.secret_token.present?
    sl = params[:shogun_lang].to_s
    url = "#{Shogun.preview_url}/previews/#{params[:uuid].to_s}"
    if sl.present?
      url += "?lang=#{sl}"
    end
    r = HTTP.headers("X-Secret-Token" => Shogun.secret_token).get(url)
    not_found! unless r.status.code == 200
    @html = r.to_s
    render layout: Shogun.layout
  end
end
