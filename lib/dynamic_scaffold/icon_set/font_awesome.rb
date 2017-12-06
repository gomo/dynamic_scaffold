Rails.application.config.dynamic_scaffold.icons = proc do |name|
  case name
  when :up then
    content_tag :i, '', class: 'fa fa-chevron-up', 'aria-hidden' => 'true'
  when :down then
    content_tag :i, '', class: 'fa fa-chevron-down', 'aria-hidden' => 'true'
  when :delete then
    content_tag :i, '', class: 'fa fa-times', 'aria-hidden' => 'true'
  when :edit then
    content_tag :i, '', class: 'fa fa-pencil', 'aria-hidden' => 'true'
  when :add then
    content_tag :i, '', class: 'fa fa-plus', 'aria-hidden' => 'true'
  when :save then
    content_tag :i, '', class: 'fa fa-hdd-o', 'aria-hidden' => 'true'
  when :back then
    content_tag :i, '', class: 'fa fa-chevron-left', 'aria-hidden' => 'true'
  when :error then
    content_tag :i, '', class: 'fa fa-exclamation-circle', 'aria-hidden' => 'true'
  else
    raise DynamicScaffold::Error::InvalidIcon, "Unknown icon type #{name} specified."
  end
end
