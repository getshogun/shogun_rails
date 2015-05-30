require "http"

class Shogun::PreviewsController < ApplicationController
  def show
    not_found! unless Shogun.secret_token.present?
    r = HTTP.headers("X-Secret-Token" => Shogun.secret_token).get("#{Shogun.preview_url}/previews/#{params[:uuid].to_s}")
    not_found! unless r.status.code == 200
    @html = r.to_s
    render layout: Shogun.layout
  end

  private

  def not_found!
    raise ActionController::RoutingError.new('Not Found')
  end
end
