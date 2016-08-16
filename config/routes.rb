Rails.application.routes.draw do
  resources :petitions, except:[:new]

  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :contents do

  member do
    get 'aprobar'
    get 'descarga'
  end
    resources :rates, only: [:create, :update]
    resources :comments, only: [:create, :destroy]
  end

  resource :publications, only: [:show]

  resources :categories, except: [:new, :show, :edit]


  get 'verPeticiones', to: 'administrator#verPeticiones'
  get 'adminPanel',    to: 'administrator#panelAdmin'
  get 'mostrar_peticion/:id', to: 'administrator#mostrar_peticion'
  get 'aceptar_peticion/:id', to: 'administrator#aceptar_peticion' 
  get 'rechazar_peticion/:id', to: 'administrator#rechazar_peticion'
  post 'eliminar_categorias', to: 'categories#eliminar_categorias'
  get 'new_password', to: 'user_extra#nueva_clave'
  post 'responder_pregunta', to: 'user_extra#crear_clave'
  post 'change_password', to: 'user_extra#cambiar_clave'
  get 'change_pass', to: 'user_extra#change_pass'
  post 'download_backup', to: 'administrator#download_backup'
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
