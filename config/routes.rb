Psychlopedia::Application.routes.draw do
  # experiences
  scope(path_names: {new: 'nueva'}) do
    resources :experiences, path: 'experiencias'
  end

  get 'random', to: 'experiences#random'
  get 'search', to: 'experiences#search'

  get 'about', to: 'infrastructure#about', path: 'que'
  get 'style', to: 'infrastructure#style', path: 'estilo'
  get 'legal', to: 'infrastructure#legal', path: 'legal'
  get 'privacy', to: 'infrastructure#privacy', path: 'privacidad'

  root to: 'experiences#index'
end
