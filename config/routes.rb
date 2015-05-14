if Shogun.automount
  Rails.application.routes.draw do
    get '/shogun/previews/:uuid' => 'shogun/previews#show'
    get '/(*path)' => 'shogun/pages#show'
  end
else
  Rails.application.routes.draw do
    get '/shogun/previews/:uuid' => 'shogun/previews#show'
  end

  Shogun::Engine.routes.draw do
    get '/(*path)' => 'pages#show'
  end
end
