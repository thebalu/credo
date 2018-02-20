Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/api/review/get_card', to: 'reviews#get_card'

  post '/api/review/answer_card', to: 'reviews#answer_card'

  resources :decks
  resources :cards
  resources :students
  resources :klasses
end
