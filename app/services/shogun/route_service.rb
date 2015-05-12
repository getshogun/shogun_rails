require "http"
require "hamster/hash"
require "hamster/set"

module Shogun
  class RouteService
    include Singleton

    def initialize
      @pages = Hamster.hash
      @last = Hamster.set
      @lock = Mutex.new
    end

    def [](path)
      return nil unless @pages.present?
      @pages[path]
    end

    def reload!
      begin
        @lock.synchronize { _reload! }
      rescue
      end
    end

    private

    def _reload!
      unless Shogun.secret_token.present?
        Rails.logger.warn "Missing Shogun.secret_token!"
        return
      end

      unless Shogun.site_id.present?
        Rails.logger.warn "Missing Shogun.site_id!"
        return
      end

      response = HTTP.get "#{Shogun.url}/#{Shogun.site_id}/#{Shogun.secret_token}-raw_html.json"

      if response.status.code == 200
        json = response.parse
        set = json.inject(Hamster.set) { |set, page| set.add(page["uuid"]) }

        unless @last == set
          @pages = json.inject(Hamster.hash) do |hash, page|
            p = {path: page["path"].downcase, html: page["raw_html"], uuid: page["uuid"]}.freeze
            hash.put(p[:path], p)
          end
          @last = set
        end
      end
    end
  end
end
