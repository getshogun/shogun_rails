class ShogunConstraint
  def matches?(request)
    Shogun::RouteService.instance[request.fullpath.split('?').first.downcase].present?
  end
end

if Shogun.automount
  Rails.application.routes.draw do
    get '/shogun/previews/:uuid' => 'shogun/previews#show'
    constraints ShogunConstraint.new do
      get '/(*path)' => 'shogun/pages#show'
    end
  end
else
  Rails.application.routes.draw do
    get '/shogun/previews/:uuid' => 'shogun/previews#show'
  end

  Shogun::Engine.routes.draw do
    constraints ShogunConstraint.new do
      get '/(*path)' => 'pages#show'
    end
  end
end
