Rails.application.routes.draw do



  get 'pulse_new', to: 'page#pulse_new'
  get 'pulse', to: 'page#pulse'
  get 'spasibo', to: 'page#spasibo'

  get 'pohudet_legko', to: 'trainings#pohudet_legko'

  get 'vip', to: 'page#vip'

  #get 'sitemap', to: 'sitemap#index', :defaults => { :format => 'xml' }
  get 'sitemap.xml', to: 'sitemap#index'

  mount Ckeditor::Engine => '/ckeditor'

  if Rails.env.production?
    get '404', :to => 'page#error_404'
  end

  get 'error_404', to: 'page#error_404'

  get  'shop',                to: 'shop#index'

  get  'shop/:order_status',  to: 'shop#order_status'
  post 'shop/order_update',   to: 'shop#order_update'
  post 'shop',                to: 'shop#order_create'


  get  'contact', to: 'contact#new'
  post 'contact', to: 'contact#create'

  post 'comments/reply_form/:training_id/:day_id/:comment_id', to: 'comments#reply_form'

  get 'feedbacks/update'

  get 'settings/info'
  patch 'settings/info', to: 'settings#info_process'

  get 'settings/email'
  patch 'settings/email', to: 'settings#email_process'

  get 'settings/notify'
  patch 'settings/notify', to: 'settings#notify_process'

  get  'settings/email_verify/:token', to: 'settings#email_verify'

  get 'settings/password'
  patch 'settings/password', to: 'settings#password_process'

  #get 'page/privacy'

  root to: 'trainings#index'

  get    'login',         to: 'auth#login'
  post   'login_for_ads', to: 'auth#login_for_ads'
  post   'login',         to: 'auth#login_process'
  patch  'login',         to: 'auth#login_process'

  get  'auth/signup_verify/:token/:training_id', to: 'auth#signup_verify'

  get  'logout', to: 'auth#logout'

  get  'signup', to: 'auth#signup'
  post 'signup', to: 'auth#signup_process'

  get  'remember', to: 'auth#remember'
  post 'remember', to: 'auth#remember_process'

  get  'password_recovery/:token', to: 'auth#password_recovery'
  patch 'password_recovery/:token', to: 'auth#password_recovery_process'

  get  'signup_complete', to: 'auth#signup_complete'
  post 'signup_complete', to: 'auth#signup_complete_process'

  resources :my_trainings do

    collection do
      get 'hide/:id',  to: 'my_trainings#hide'
      get 'show/:id',  to: 'my_trainings#show'
    end

  end

  resources :trainings do

    collection do
      get 'next/:id',     to: 'trainings#next'
      get 'previous/:id', to: 'trainings#previous'
    end

    resources :feedbacks

    resources :days do

      resources :comments

    end

  end

  # Для администратора

  get 'admin', to: 'admin/trainings#index'

  namespace :admin do
    resources :feedbacks
    resources :comments
    resources :questions
    resources :day_attachments
    resources :training_attachments
    resources :trainings do
      resources :days do
        collection do
          get 'select_field'
        end
      end

      collection do
        post 'ajax_weight'
      end
    end
    resources :categories
    resources :users
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
