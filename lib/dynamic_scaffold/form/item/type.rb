module DynamicScaffold
  module Form
    module Item
      class Type
        LIST = {
          check_box: Form::Item::SingleOption,
          radio_button: Form::Item::SingleOption,
          text_area: Form::Item::SingleOption,
          text_field: Form::Item::SingleOption,
          date_field: Form::Item::SingleOption,
          password_field: Form::Item::SingleOption,
          hidden_field: Form::Item::SingleOption,
          file_field: Form::Item::SingleOption,
          color_field: Form::Item::SingleOption,
          number_field: Form::Item::SingleOption,
          telephone_field: Form::Item::SingleOption,

          time_select: Form::Item::TwoOptions,
          date_select: Form::Item::TwoOptions,
          datetime_select: Form::Item::TwoOptions,
          collection_select: Form::Item::TwoOptions,
          grouped_collection_select: Form::Item::TwoOptions,

          collection_check_boxes: Form::Item::TwoOptionsWithBlock,
          collection_radio_buttons: Form::Item::TwoOptionsWithBlock,

          block: Form::Item::Block,

          carrierwave_image: Form::Item::CarrierWaveImage,

          globalize_fields: Form::Item::GlobalizeFields,

          cocoon: Form::Item::Cocoon,

          json_object: Form::Item::JSONObject
        }.freeze
      end
    end
  end
end
