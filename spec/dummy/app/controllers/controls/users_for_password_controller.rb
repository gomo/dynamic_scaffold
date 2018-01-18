module Controls
  class UsersForPasswordController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold User do |c|
      c.form.item :hidden, :id
      c.form.item :text, :email
      c.form.item(:text, :encrypted_password)
        .label('FooBar')
        .if {|p| %w[new create].include? p[:action] }
      c.form.item(:text, :password)
        .proxy(:encrypted_password)
        .if {|p| %w[edit update].include? p[:action] }
    end
  end
end
