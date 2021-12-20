# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Proxy' do
    render_views
    it 'should display the values of the attribute specifying the label and error message.' do
      controller.class.send(:dynamic_scaffold, User) do |c|
        c.form.item(:hidden_field, :id)
        c.form.item(:text_field, :password).label('FooBar').if { false }
        c.form.item(:text_field, :password_for_edit).proxy(:password)
      end

      user = FactoryBot.create(:user)
      get :edit, params: { locale: :en, id: user.id }
      body = response.body.delete!("\n").gsub!(/> +</, '><')
      expect(body).to match(
        /
          <label\ class="ds-label">FooBar<\/label>
          <div\ class="ds-form-item"><input\ class="form-control"\ type="text"\ name="user\[password_for_edit\]"
        /x
      )

      patch :update, params: {
        locale: :en,
        id: user.id,
        user: {
          id: user.id,
          password_for_edit: 'a'
        }
      }
      body = response.body.delete!("\n").gsub!(/> +</, '><')
      expect(body).to match(
        /<\/svg> Password is too short \(minimum is [0-9]+ characters\)<\/li>/
      )
    end
  end
end
