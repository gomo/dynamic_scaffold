module DynamicScaffold
  module Fontawesome
    def self.inline_svg(path)
      Rails.cache.fetch "dynamic_scaffold/fontawesome/icons/#{path}" do
        full_path = DynamicScaffold::Engine.root.join('app', 'assets', 'images', 'dynamic_scaffold', 'fontawesome', path)
        file = File.open(full_path)
        file.read.gsub!('<svg ', '<svg class="dynamicScaffold-svg-icon" ').html_safe # rubocop:disable Rails/OutputSafety, Metrics/LineLength
      end
    end
  end
end
Rails.application.config.dynamic_scaffold.icons = proc do |name| # rubocop:disable Metrics/BlockLength
  # This function is called in view scope.
  # https://github.com/gomo/dynamic_scaffold/blob/b4066bbd40cd6e7307ce283d5a9bd526ae124e00/lib/dynamic_scaffold/controller_utilities.rb#L104-L106
  case name
  when :up then
    DynamicScaffold::Fontawesome.inline_svg('chevron-up.svg')
  when :down then
    DynamicScaffold::Fontawesome.inline_svg('chevron-down.svg')
  when :delete then
    DynamicScaffold::Fontawesome.inline_svg('times.svg')
  when :edit then
    DynamicScaffold::Fontawesome.inline_svg('pencil-alt.svg')
  when :add then
    DynamicScaffold::Fontawesome.inline_svg('plus.svg')
  when :save then
    DynamicScaffold::Fontawesome.inline_svg('hdd.svg')
  when :back then
    DynamicScaffold::Fontawesome.inline_svg('chevron-left.svg')
  when :error then
    DynamicScaffold::Fontawesome.inline_svg('exclamation-circle.svg')
  when :first then
    DynamicScaffold::Fontawesome.inline_svg('step-backward.svg')
  when :last then
    DynamicScaffold::Fontawesome.inline_svg('step-forward.svg')
  when :next then
    DynamicScaffold::Fontawesome.inline_svg('chevron-right.svg')
  when :prev then
    DynamicScaffold::Fontawesome.inline_svg('chevron-left.svg')
  else
    raise DynamicScaffold::Error::InvalidIcon, "Unknown icon type #{name} specified."
  end
end
