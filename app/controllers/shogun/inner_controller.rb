class Shogun::InnerController < ApplicationController
  def show
    d = Digest::SHA256.hexdigest "#{Shogun.site_id}-#{Shogun.secret_token}"
    return head :unauthorized unless params[:d] == d
    response.headers.except! 'X-Frame-Options'
    render layout: Shogun.layout
  end
end
