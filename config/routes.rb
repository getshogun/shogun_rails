Shogun::Engine.routes.draw do
  Shogun::RouteService.cached.each do |route|
    get route.path => 'pages#show'
  end
  get "/shogun/previews/:uuid" => 'previews#show'
end

Rails.application.routes.draw do
  mount Shogun::Engine => "/", as: "shogun_mount"
end
