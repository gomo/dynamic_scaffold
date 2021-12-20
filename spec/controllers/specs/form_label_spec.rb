# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'form label' do
    render_views
    context 'No call label method' do
      it 'should create model name label.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name)
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="ds-label">Name<\/label>/)
      end
    end
    context 'Call with only name' do
      it 'should create specified label.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name).label('Foobar')
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="ds-label">Foobar<\/label>/)
      end
    end
    context 'Call with name and attributes' do
      it 'should create specified label with attributes.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name).label('Foobar', class: 'quz')
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="ds-label quz">Foobar<\/label>/)
      end
    end
    context 'Call with only attributes' do
      it 'should create model name label with attributes.' do
        controller.class.send(:dynamic_scaffold, Shop) do |c|
          c.form.item(:text_field, :name).label(class: 'quz')
        end

        get :new, params: { locale: :en }
        body = response.body.delete!("\n").gsub!(/> +</, '><')
        expect(body).to match(/<label class="ds-label quz">Name<\/label>/)
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
        expect(body).to match(/<label class="ds-label hoge">Foobar<\/label>/)
      end
    end
  end
end
