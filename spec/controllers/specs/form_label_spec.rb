require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'form label' do
    after(:each) do
      DynamicScaffold.reset
    end
    render_views
    context 'No call label method' do
      it 'should create model name label.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name)
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label>Name<\/label>/)
      end
    end
    context 'Call with only name' do
      it 'should create specified label.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name).label('Foobar')
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label>Foobar<\/label>/)
      end
    end
    context 'Call with name and attributes' do
      it 'should create specified label with attributes.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name).label('Foobar', class: 'quz')
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="quz">Foobar<\/label>/)
      end
    end
    context 'Call with only attributes' do
      it 'should create model name label with attributes.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name).label(class: 'quz')
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="quz">Name<\/label>/)
      end
    end
    context 'Call with block' do
      it 'should create specified tag.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name).label do |text|
            tag.label text, class: :block
          end
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="block">Name<\/label>/)
      end
    end
    context 'Call with block and name' do
      it 'should change argment to sepcified.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name).label :Foobar do |text|
            tag.label text, class: :block
          end
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="block">Foobar<\/label>/)
      end
    end
    context 'Call with block and name and attr' do
      it 'should change argment to sepcified.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name).label(:Foobar, class: :hoge) do |text, _depth, attrs|
            tag.label text, attrs
          end
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="hoge">Foobar<\/label>/)
      end
    end
    context 'Global config' do
      it 'should create specified tag.' do
        DynamicScaffold.configure do |config|
          config.form.label do |text, depth|
            tag.label text, class: :global
          end
        end

        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name)
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="global">Name<\/label>/)
      end

      context 'Overwrite text' do
        it 'should change argment to sepcified.' do
          DynamicScaffold.configure do |config|
            config.form.label do |text, depth|
              tag.label text, class: :global
            end
          end

          controller.class.send(:dynamic_scaffold, Shop) do |c|
            c.form.item(:text_field, :name).label(:Foobar)
          end

          get :new, params: { locale: :en }
          body = response.body.delete!("\n").gsub!(/> +</, '><')
          expect(body).to match(/<label class="global">Foobar<\/label>/)
        end
      end
      context 'Overwrite attr' do
        it 'should change argment to sepcified.' do
          DynamicScaffold.configure do |config|
            config.form.label do |text, _depth, attrs|
              tag.label text, { class: :global }.merge(attrs)
            end
          end

          controller.class.send(:dynamic_scaffold, Shop) do |c|
            c.form.item(:text_field, :name).label(class: :hoge)
          end

          get :new, params: { locale: :en }
          body = response.body.delete!("\n").gsub!(/> +</, '><')
          expect(body).to match(/<label class="hoge">Name<\/label>/)
        end
      end
      context 'Overwrite name and attr' do
        it 'should change argment to sepcified.' do
          DynamicScaffold.configure do |config|
            config.form.label do |text, _depth, attrs|
              tag.label text, { class: :global }.merge(attrs)
            end
          end

          controller.class.send(:dynamic_scaffold, Shop) do |c|
            c.form.item(:text_field, :name).label(:Foobar, class: :hoge)
          end

          get :new, params: { locale: :en }
          body = response.body.delete!("\n").gsub!(/> +</, '><')
          expect(body).to match(/<label class="hoge">Foobar<\/label>/)
        end
      end
    end
  end
end
