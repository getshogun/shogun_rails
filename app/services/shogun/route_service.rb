require "http"
require "hamster/hash"
require "set"

module Shogun
  class RouteService
    include Singleton

    def initialize
      @pages = Hamster::Hash[]
    end

    def [](path)
      return nil unless @pages.present?
      @pages[path]
    end

    def reload!
      begin
        _reload!
      rescue
      end
    end

    def html(uuid, lang=nil)
      if lang.present?
        r = HTTP.get "#{Shogun.url}/#{uuid}.#{lang}.html"
      else
        r = HTTP.get "#{Shogun.url}/#{uuid}.html"
      end
      return nil unless r.status.code == 200
      r.to_s
    end

    private

    def _reload!
      response = HTTP.get "#{Shogun.url}/#{Shogun.site_id}-#{Shogun.secret_token}.json"

      if response.status.code == 200
        json = response.parse
        set = json.each_with_object(Set.new) { |page, set| set.add(page["uuid"]) }

        unless Set.new(@pages.values.to_a) == set
          @pages = json.inject(Hamster::Hash[]) do |hash, page|
            hash.put(page["path"].downcase, Hamster::Hash["uuid" => page["uuid"], "languages" => page["languages"], "meta_tags" => page["meta_tags"].to_a])
          end
        end
      end
    end
  end
end
