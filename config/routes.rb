class ShogunConstraint
  def matches?(request)
    Shogun::RouteService.instance[request.fullpath.split('?').first.downcase].present?
  end
end

if Shogun.site_id.present? && Shogun.secret_token.present?
  Rails.application.routes.draw do
    get '/shogun/previews/:uuid' => 'shogun/previews#show'
    get '/shogun/editor' => 'shogun/editor#show'
  end

  if Shogun.automount
    Rails.application.routes.draw do
      constraints ShogunConstraint.new do
        get '/(*path)' => 'shogun/pages#show'
      end
    end
  else
    Shogun::Engine.routes.draw do
      constraints ShogunConstraint.new do
        get '/(*path)' => 'pages#show'
      end
    end
  end
end
