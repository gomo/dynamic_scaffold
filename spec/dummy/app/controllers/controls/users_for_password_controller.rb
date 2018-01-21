module Controls
  class UsersForPasswordController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold User do |c|
      c.form.item :hidden_field, :id
      c.form.item :text_field, :email
      c.form.item(:text_field, :encrypted_password)
        .label('FooBar')
        .if {|p| %w[new create].include? p[:action] }
      c.form.item(:text_field, :password)
        .proxy(:encrypted_password)
        .if {|p| %w[edit update].include? p[:action] }
    end
  end
end
