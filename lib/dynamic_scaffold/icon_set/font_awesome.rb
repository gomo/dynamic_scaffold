Rails.application.config.dynamic_scaffold.icons = proc do |name|
  case name
  when :up_icon then
    content_tag :i, '', class: 'fa fa-chevron-up', 'aria-hidden' => 'true'
  when :down_icon then
    content_tag :i, '', class: 'fa fa-chevron-down', 'aria-hidden' => 'true'
  when :delete_icon then
    content_tag :i, '', class: 'fa fa-times', 'aria-hidden' => 'true'
  when :edit_icon then
    content_tag :i, '', class: 'fa fa-pencil', 'aria-hidden' => 'true'
  when :add_icon then
    content_tag :i, '', class: 'fa fa-plus', 'aria-hidden' => 'true'
  when :save_icon then
    content_tag :i, '', class: 'fa fa-hdd-o', 'aria-hidden' => 'true'
  else
    raise "Unknown icon type #{name} specified."
  end
end
