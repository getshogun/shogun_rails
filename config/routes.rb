if Shogun.automount
  Rails.application.routes.draw do
    get '/shogun/previews/:uuid' => 'shogun/previews#show'
    get '/(*path)' => 'shogun/pages#show'
  end
else
  Shogun::Engine.routes.draw do
    get '/shogun/previews/:uuid' => 'shogun/previews#show'
    get '/(*path)' => 'shogun/pages#show'
  end
end
