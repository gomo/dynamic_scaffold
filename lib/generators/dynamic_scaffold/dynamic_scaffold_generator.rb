class DynamicScaffoldGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :path, type: 'string', required: true
  argument :model, type: 'string', required: false

  def create_controller
    @namespases = path.split('/')
    @plural_model_name = @namespases.pop.camelize
    @class_scope = @namespases.map(&:camelize).join('::')
    @model_name = model ? model : @plural_model_name.singularize
    @model_name = @model_name.camelize
    @model = @model_name.constantize
    template 'controller.erb', "app/controllers/#{path}_controller.rb"
  end
end
