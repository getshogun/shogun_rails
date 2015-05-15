require "shogun/engine"

module Shogun
  mattr_accessor :daemon
  mattr_accessor :preview_url
  mattr_accessor :site_id
  mattr_accessor :reload_frequency
  mattr_accessor :secret_token
  mattr_accessor :url
  mattr_accessor :layout
  mattr_accessor :automount
end

Shogun.url = "https://getshogun-production.global.ssl.fastly.net"
Shogun.preview_url = "https://getshogun.com"
Shogun.automount = true
