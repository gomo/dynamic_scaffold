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
end
