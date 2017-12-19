Rails.application.routes.draw do

  resources :items, only: :create do
    collection do
      get '*path' => 'items#show', as: :download, format: false
      delete '*path' => 'items#destroy', format: false
    end
  end
end
