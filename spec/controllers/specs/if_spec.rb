require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'If' do
    render_views
    it 'should render the field if it returns true, otherwise no render.' do
      controller.class.send(:dynamic_scaffold, User) do |c|
        c.form.item(:text_field, :password)
          .if {|p| %w[new create].include? p[:action] }
        c.form.item(:text_field, :password_for_edit)
          .if {|p| %w[edit update].include? p[:action] }
      end

      get :new, params: { locale: :en }
      body = response.body.delete!("\n").gsub!(/> +</, '><')
      expect(body).to match(
        /<input[^>]+name="user\[password\]"/
      )
      expect(body).not_to match(/name="user\[password_for_edit\]"/)

      user = FactoryBot.create(:user)
      get :edit, params: { locale: :en, id: user.id }
      body = response.body.delete!("\n").gsub!(/> +</, '><')
      expect(body).to match(
        /<input[^>]+name="user\[password_for_edit\]"/
      )
      expect(body).not_to match(/name="user\[password\]"/)
    end
  end
end
