# frozen_string_literal: true

class DynamicScaffoldGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  argument :path, type: 'string', required: true
  argument :model, type: 'string', required: false
  class_option :content_for, type: :string
  class_option :controller_base, type: :string, default: 'ApplicationController'

  def init
    @namespases = path.split('/')
    @plural_model_name = @namespases.pop.camelize
    @class_scope = @namespases.map(&:camelize).join('::')
    @model_name = model || @plural_model_name.singularize
    @model_name = @model_name.camelize
    @model = @model_name.constantize
    @content_for = options['content_for']
    @controller_base = options['controller_base']
  end

  def create_controllers
    template 'controller.erb', "app/controllers/#{path}_controller.rb"
  end

  def create_views
    %i[edit index new].each do |file|
      template "views/#{file}.erb", "app/views/#{path}/#{file}.html.erb"
    end
  end
end
