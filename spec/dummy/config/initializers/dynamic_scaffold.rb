DynamicScaffold.configure do |config|
  config.form.label do |text, depth|
    if depth == 0
      tag.div class: 'h3 mb-1' do
        tag.label text
      end
    end
  end
end
