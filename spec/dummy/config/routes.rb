Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope "/:locale" do
    namespace 'controls' do
      scope 'master', as: :master do
        dynamic_scaffold_for 'country'
        dynamic_scaffold_for 'state'
      end
    end
  end
end
