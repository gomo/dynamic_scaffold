# frozen_string_literal: true

module DynamicScaffold
  module Fontawesome
    def self.inline_svg(path)
      Rails.cache.fetch "dynamic_scaffold/fontawesome/icons/#{path}" do
        full_path = DynamicScaffold::Engine.root.join('app', 'assets', 'images', 'dynamic_scaffold', 'fontawesome', path)
        file = File.open(full_path)
        file.read.gsub!('<svg ', '<svg class="ds-svg-icon" ').html_safe # rubocop:disable Rails/OutputSafety
      end
    end
  end
end
Rails.application.config.dynamic_scaffold.icons = proc do |name|
  # This function is called in view scope.
  # https://github.com/gomo/dynamic_scaffold/blob/b4066bbd40cd6e7307ce283d5a9bd526ae124e00/lib/dynamic_scaffold/controller_utilities.rb#L104-L106
  case name
  when :up
    DynamicScaffold::Fontawesome.inline_svg('chevron-up.svg')
  when :down
    DynamicScaffold::Fontawesome.inline_svg('chevron-down.svg')
  when :delete
    DynamicScaffold::Fontawesome.inline_svg('times.svg')
  when :edit
    DynamicScaffold::Fontawesome.inline_svg('pencil-alt.svg')
  when :add
    DynamicScaffold::Fontawesome.inline_svg('plus.svg')
  when :save
    DynamicScaffold::Fontawesome.inline_svg('hdd.svg')
  when :back
    DynamicScaffold::Fontawesome.inline_svg('chevron-left.svg')
  when :error
    DynamicScaffold::Fontawesome.inline_svg('exclamation-circle.svg')
  when :first
    DynamicScaffold::Fontawesome.inline_svg('step-backward.svg')
  when :last
    DynamicScaffold::Fontawesome.inline_svg('step-forward.svg')
  when :next
    DynamicScaffold::Fontawesome.inline_svg('chevron-right.svg')
  when :prev
    DynamicScaffold::Fontawesome.inline_svg('chevron-left.svg')
  when :top
    DynamicScaffold::Fontawesome.inline_svg('angle-double-up.svg')
  when :bottom
    DynamicScaffold::Fontawesome.inline_svg('angle-double-down.svg')
  when :times
    DynamicScaffold::Fontawesome.inline_svg('times.svg')
  else
    raise DynamicScaffold::Error::InvalidIcon, "Unknown icon type #{name} specified."
  end
end
