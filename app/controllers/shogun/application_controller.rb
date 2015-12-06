module Shogun
  class ApplicationController < ::ApplicationController
    helper Rails.application.routes.url_helpers
    include ActionView::Helpers::TagHelper
  end
end

class ::ApplicationController
  def shogun_meta_tags
    @shogun_meta_tags.to_a.map do |t|
      tag :meta, name: t["property"], content: t["value"]
    end.join.html_safe
  end

  helper_method :shogun_meta_tags
end
