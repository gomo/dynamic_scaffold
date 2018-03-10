Rails.application.routes.draw do
  root 'root#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/:locale' do
    dynamic_scaffold_for 'specs'
    
    namespace 'bootstrap3' do
      dynamic_scaffold_for 'countries'
    end
    namespace 'controls' do
      scope 'master', as: :master do
        dynamic_scaffold_for 'countries'
        dynamic_scaffold_for 'states'
        dynamic_scaffold_for 'shops'
        dynamic_scaffold_for 'shops_block'
        dynamic_scaffold_for 'users/:role', controller: 'users', role: Regexp.new(User.roles.keys.join('|')), as: :users
        dynamic_scaffold_for 'users_for_password'
        dynamic_scaffold_for 'countries_for_pagination'
        dynamic_scaffold_for 'countries_for_vars'
      end
    end
  end
end
