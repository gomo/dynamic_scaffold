module DynamicScaffold
  class << self; attr_accessor :fontawesome_cache; end
  self.fontawesome_cache = {}
end
Rails.application.config.dynamic_scaffold.icons = proc do |name| # rubocop:disable Metrics/BlockLength
  def inline_svg(path)
    unless DynamicScaffold.fontawesome_cache.key?(path)
      full_path = DynamicScaffold::Engine.root.join('app', 'assets', 'images', 'dynamic_scaffold', 'fontawesome', path)
      file = File.open(full_path)
      DynamicScaffold.fontawesome_cache[path] = file.read.gsub!('<svg ', '<svg class="dynamicScaffold-svg-icon" ').html_safe
    end
    DynamicScaffold.fontawesome_cache[path]
  end

  case name
  when :up then
    inline_svg('chevron-up.svg')
  when :down then
    inline_svg('chevron-down.svg')
  when :delete then
    inline_svg('times.svg')
  when :edit then
    inline_svg('pencil-alt.svg')
  when :add then
    inline_svg('plus.svg')
  when :save then
    inline_svg('hdd.svg')
  when :back then
    inline_svg('chevron-left.svg')
  when :error then
    inline_svg('exclamation-circle.svg')
  when :first then
    inline_svg('step-backward.svg')
  when :last then
    inline_svg('step-forward.svg')
  when :next then
    inline_svg('chevron-right.svg')
  when :prev then
    inline_svg('chevron-left.svg')
  else
    raise DynamicScaffold::Error::InvalidIcon, "Unknown icon type #{name} specified."
  end
end
