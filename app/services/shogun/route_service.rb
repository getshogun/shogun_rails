require "httparty"
require "set"

module Shogun
  class RouteServicePage < Struct.new(:path, :raw_html, :uuid)
  end

  class RouteService
    include HTTParty

    DEFAULT = [].freeze

    base_uri Shogun.url

    def self.[](path)
      return nil unless @indexed.present?
      @indexed[path]
    end

    def self.reload!
      begin
        lock.synchronize { _reload! }
      rescue
      end
    end

    private

    def self.lock
      @lock ||= Mutex.new
    end

    def self._reload!
      unless Shogun.secret_token.present?
        Rails.logger.warn "Missing Shogun.secret_token!"
        return DEFAULT
      end

      unless Shogun.site_id.present?
        Rails.logger.warn "Missing Shogun.site_id!"
        return DEFAULT
      end

      response = get "/#{Shogun.site_id}/#{Shogun.secret_token}-raw_html.json"

      if response.success?
        json = response.parsed_response
        r = json.map { |page| RouteServicePage.new(page["path"].downcase, page["raw_html"], page["uuid"]).freeze }
        @indexed = r.index_by(&:path).freeze
      end
    end
  end
end
