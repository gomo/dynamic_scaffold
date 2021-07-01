require 'dynamic_scaffold/version'
require 'dynamic_scaffold/engine'
require 'dynamic_scaffold/monkeypatch/action_view/helpers/form_builder'
require 'dynamic_scaffold/routes'
require 'dynamic_scaffold/controller_utilities'
require 'dynamic_scaffold/controller'
require 'dynamic_scaffold/config'
require 'dynamic_scaffold/list_builder'
require 'dynamic_scaffold/form_builder'
require 'dynamic_scaffold/title'
require 'dynamic_scaffold/vars'

module DynamicScaffold
  module Error
    autoload :Base,             'dynamic_scaffold/error/base'
    autoload :InvalidIcon,      'dynamic_scaffold/error/invalid_icon'
    autoload :InvalidParameter, 'dynamic_scaffold/error/invalid_parameter'
    autoload :InvalidOperation, 'dynamic_scaffold/error/invalid_operation'
  end

  module List
    autoload :Item, 'dynamic_scaffold/list/item'
    autoload :Pagination, 'dynamic_scaffold/list/pagination'
  end

  module Form
    module Item
      autoload :Type,                 'dynamic_scaffold/form/item/type'
      autoload :Base,                 'dynamic_scaffold/form/item/base'
      autoload :Block,                'dynamic_scaffold/form/item/block'
      autoload :CarrierWaveImage,     'dynamic_scaffold/form/item/carrier_wave_image'
      autoload :SingleOption,         'dynamic_scaffold/form/item/single_option'
      autoload :TwoOptionsWithBlock,  'dynamic_scaffold/form/item/two_options_with_block'
      autoload :TwoOptions,           'dynamic_scaffold/form/item/two_options'
      autoload :GlobalizeFields,      'dynamic_scaffold/form/item/globalize_fields'
      autoload :Cocoon,               'dynamic_scaffold/form/item/cocoon'
      autoload :JSONObject,           'dynamic_scaffold/form/item/json_object'
    end
  end

  module JSONObject
    autoload :Attribute,              'dynamic_scaffold/json_object/attribute'
    autoload :Model,                  'dynamic_scaffold/json_object/model'
  end
end
