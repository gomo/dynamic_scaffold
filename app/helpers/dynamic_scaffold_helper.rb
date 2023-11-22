# frozen_string_literal: true

module DynamicScaffoldHelper
  def render_form_errors(errors)
    return '' if errors.blank?

    tag.ul(class: 'list-unstyled ds-error-message') do
      errors.each do |message|
        concat tag.li("#{dynamic_scaffold_icon :error} #{message}".html_safe) # rubocop:disable Rails/OutputSafety
      end
    end
  end

  def dynamic_scaffold_icon(name)
    instance_exec name, &::Rails.application.config.dynamic_scaffold.icons
  end

  def render_check_box(form, field, value, label, input_options = {}, label_options = {}) # rubocop:disable Metrics/ParameterLists, Metrics/LineLength
    id = "#{field.name}_#{value}"
    concat(
      form.check_box(
        field.name, {
          id: id,
          multiple: field.multiple,
          include_hidden: false,
          **input_options
        },
        value
      )
    )
    concat tag.label label, for: id, **label_options
  end
end
