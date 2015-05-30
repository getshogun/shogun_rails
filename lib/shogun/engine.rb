module Shogun
  class Engine < ::Rails::Engine
    isolate_namespace Shogun

    initializer "shogun.init" do
      Shogun.secret_token ||= ENV["SHOGUN_SECRET_TOKEN"]
      Shogun.site_id ||= ENV["SHOGUN_SITE_ID"]
      Shogun.reload_frequency ||= 5
      Shogun.layout ||= "application"

      Shogun::RouteService.instance.reload!

      Shogun.daemon = Proc.new do
        if Shogun.secret_token.nil?
          Rails.logger.warn "Missing Shogun.secret_token!"
        elsif Shogun.site_id.nil?
          Rails.logger.warn "Missing Shogun.site_id!"
        else
          Thread.new do
            loop do
              Shogun::RouteService.instance.reload!
              sleep(Shogun.reload_frequency)
            end
          end
        end
      end

      if defined?(Puma)
        if Puma.respond_to?(:cli_config)
          Puma.cli_config.options[:before_worker_boot] << Shogun.daemon
        end
      elsif defined?(Unicorn)
        # must be manually setup
      elsif defined?(PhusionPassenger)
        PhusionPassenger.on_event(:starting_worker_process) do |forked|
          Shogun.daemon.call
        end
      else
        Shogun.daemon.call
      end
    end
  end
end
