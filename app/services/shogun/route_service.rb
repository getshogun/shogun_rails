require "httparty"
require "set"

module Shogun
  class RouteServicePage < Struct.new(:path, :raw_html, :uuid)
  end

  class RouteService
    include HTTParty

    base_uri Shogun.url

    def self.lock
      @lock ||= Mutex.new
    end

    def self.[](path)
      @all.index_by(&:path)[path]
    end

    def self.cached
      @all || []
    end

    def self.all
      unless Shogun.secret_token.present?
        Rails.logger.warn "Missing Shogun.secret_token!"
        return @all = []
      end

      unless Shogun.site_id.present?
        Rails.logger.warn "Missing Shogun.site_id!"
        return @all = []
      end

      response = get "/#{Shogun.site_id}/#{Shogun.secret_token}-raw_html.json"

      if response.success?
        json = response.parsed_response
        @all = json.map do |page|
          RouteServicePage.new(page["path"], page["raw_html"], page["uuid"])
        end
      else
        @all = [] unless @all.present? && @all.any?
      end
    end

    def self.reload_shogun_route_set!
      Rails.application.routes_reloader.reload!
    end

    def self.reload!
      begin
        lock.synchronize do
          pages = all

          current = Set.new(pages.map(&:uuid))

          # only reload the routes if there are changes

          if @loaded.present?
            if current != @loaded
              @loaded = current
              reload_shogun_route_set!
            end
          else
            @loaded = current
            reload_shogun_route_set!
          end
        end
      rescue
      end
    end
  end
end
