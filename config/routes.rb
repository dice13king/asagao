Rails.application.routes.draw do
  root  to: "top#index"# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "about" => "top#about", as: "about"
  get "locale" => "top#locale", as: "locale"
  resources :members, only: [:index, :show] do
    collection { get "search" }
    resources :entries, only: [:index] #indexへは「/members/123/entries」と「/entries」の二つのパスでGETメソッドでアクセス可能
  end
  resources :articles, only: [:index, :show]
  resources :entries do
    member { patch "like", "unlike" }
    collection { get "voted" }
  end
  resource :session, only: [:create, :destroy] #単数リソース=アプリ内で秘湯しかないものを扱う
  resource :account

  namespace :admin do
    root to: "top#index"
    resources :members do
      collection { get "search" }
    end
    resources :articles
  end
  
  match "*anything" => "top#not_found", via: [:get, :post, :patch, :delete]
end
