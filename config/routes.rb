Rails.application.routes.draw do
  get '/shogun/previews/:uuid' => 'shogun/previews#show'
  get '/(*path)' => 'shogun/pages#show'
end
