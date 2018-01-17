module Controls
  class UsersForPasswordController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold User do |c|
      c.form.field :hidden, :id
      c.form.field :text, :email
      c.form.field(:text, :encrypted_password)
        .label('FooBar')
        .if {|p| %w[new create].include? p[:action] }
      c.form.field(:text, :password)
        .proxy(:encrypted_password)
        .if {|p| %w[edit update].include? p[:action] }
    end
  end
end
