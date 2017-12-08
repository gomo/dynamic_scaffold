Rails.application.routes.draw do
  # dynamic_scaffold_for 'foo'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/:locale' do
    namespace 'controls' do
      scope 'master', as: :master do
        dynamic_scaffold_for 'countries'
        dynamic_scaffold_for 'states'
        dynamic_scaffold_for 'shops'
        dynamic_scaffold_for 'users/:role', controller: 'users', role: Regexp.new(User.roles.keys.join('|'))
      end
    end
  end
end
