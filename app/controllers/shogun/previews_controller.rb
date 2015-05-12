class Shogun::PreviewsController < ApplicationController
  def show
    @uuid = params[:uuid].to_s
    render layout: Shogun.layout
  end
end
