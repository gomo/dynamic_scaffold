Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'controls' do
    scope 'master', as: :master do
      get 'country', to: 'country#index'
      get 'state', to: 'state#index'
    end
  end
end
