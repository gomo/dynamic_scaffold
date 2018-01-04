module Controls
  class UsersForPasswordController < BaseController
    include DynamicScaffold::Controller
    dynamic_scaffold User do |c|
      c.form.hidden_field :id
      c.form.text_field :email
      c.form.text_field(:encrypted_password)
        .label('FooBar')
        .if {|p| ['new', 'create'].include? p[:action]}
      c.form.text_field(:password)
        .proxy(:encrypted_password)
        .if {|p| ['edit', 'update'].include? p[:action]}
    end
  end
end
