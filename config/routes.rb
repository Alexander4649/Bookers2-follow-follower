Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
   resource :favorites,only: [:create,:destroy]
   resources :book_comments,only: [:create,:destroy]
 end

  resources :users, only: [:index,:show,:edit,:update] do
   resource :relationships,only: [:create,:destroy]
   get :followings, on: :member
   get :followers, on: :member
   #あるユーザーがフォローする人全員を表示するルーティング
   #あるユーザーをフォローしてくれている人全員を表示するルーティング(つまりフォロワー)
   #on: :menberと書く事で、ルーティングにidを持たせることができる
 end
  
  
end