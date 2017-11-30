require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context 'DynamicScaffold::Manager#forms' do
    it 'should output all columns by default.' do
      manager = DynamicScaffold::Manager.new Country

      forms = manager.forms
      expect(forms.size).to eq Country.column_names.size

      country = FactoryBot.create(:country)
      helper.form_with model: country, url: './create' do |form|
        expect(forms[0].label(form)).to eq 'Id'
        expect(forms[0].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.id}\" name=\"country[id]\" />"
        )

        expect(forms[1].label(form)).to eq 'Name'
        expect(forms[1].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.name}\" name=\"country[name]\" />"
        )

        expect(forms[2].label(form)).to eq 'Sequence'
        expect(forms[2].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.sequence}\" name=\"country[sequence]\" />"
        )

        expect(forms[3].label(form)).to eq 'Created at'
        expect(forms[3].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.created_at}\" name=\"country[created_at]\" />"
        )

        expect(forms[4].label(form)).to eq 'Updated at'
        expect(forms[4].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.updated_at}\" name=\"country[updated_at]\" />"
        )
      end
    end
  end
  context 'DynamicScaffold::Manager#add_form' do
    context 'Simple element' do
      it 'should be able to specify a label.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.add_form(:id, :text_field, 'FOOBAR')
        elem = manager.forms[0]
        helper.form_with model: country, url: './create' do |form|
          expect(elem.label(form)).to eq 'FOOBAR'
        end
      end

      it 'should use the column name for the label if you omit it.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.add_form(:id, :text_field)
        elem = manager.forms[0]
        helper.form_with model: country, url: './create' do |form|
          expect(elem.label(form)).to eq 'Id'
        end
      end

      it 'should be able to generate HTML attributes with the last hash argument.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.add_form(
          :id,
          :text_field,
          class: 'foobar',
          'data-foobar' => 'foobar value',
          style: 'width: 50%;'
        )
        elem = manager.forms[0]
        helper.form_with model: country, url: './create' do |form|
          expect(elem.render(form)).to(
            eq "<input data-foobar=\"foobar value\" style=\"width: 50%;\" class=\"foobar\" type=\"text\" value=\"#{country.id}\" name=\"country[id]\" />"
          )
        end
      end

      it 'should be able to add class attributes with the last argument of render.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.add_form(
          :id,
          :text_field,
          class: 'foobar'
        )
        elem = manager.forms[0]
        helper.form_with model: country, url: './create' do |form|
          expect(elem.render(form, 'add')).to(
            eq "<input class=\"foobar add\" type=\"text\" value=\"#{country.id}\" name=\"country[id]\" />"
          )
        end
      end
    end
    context 'Check boxes' do
      it 'should be able to render checkboxes.' do
        FactoryBot.create_list(:state, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.add_form(:states, :check_boxes, State.all, :id, :name)
        elem = manager.forms[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.type?(:check_boxes)).to be true
          num = 0
          elem.render(form) do |b|
            state = State.all.offset(num).first
            expect(b.label).to eq "<label for=\"shop_states_#{num + 1}\">#{state.name}</label>"
            expect(b.check_box).to eq "<input type=\"checkbox\" value=\"#{state.id}\" name=\"shop[states][]\" id=\"shop_states_#{num + 1}\" />"
            num += 1
          end
        end
      end
      it 'should be able to specify a label.' do
        FactoryBot.create_list(:state, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.add_form(:states, :check_boxes, State.all, :id, :name, 'State')
        elem = manager.forms[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.label(form)).to eq 'State'
        end
      end
      it 'should return nil for the label if you omit it.' do
        FactoryBot.create_list(:state, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.add_form(:states, :check_boxes, State.all, :id, :name)
        elem = manager.forms[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.label(form)).to be_nil
        end
      end
      it 'should be able to send options and html attributes to collection_check_boxes.' do
        FactoryBot.create_list(:state, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.add_form(
          :states,
          :check_boxes,
          State.all,
          :id,
          :name,
          'State', {
            disabled: State.all.map(&:id)
          }, {
            class: 'foobar',
            style: 'font-size: 20px;'
          }
        )
        elem = manager.forms[0]
        helper.form_with model: shop, url: './create' do |form|
          num = 0
          elem.render(form) do |b|
            state = State.all.offset(num).first
            expect(b.check_box).to eq(
              "<input style=\"font-size: 20px;\" class=\"foobar\" disabled=\"disabled\" type=\"checkbox\" value=\"#{state.id}\" name=\"shop[states][]\" id=\"shop_states_#{num + 1}\" />"
            )
            num += 1
          end
        end
      end
    end
    context 'Radio buttons' do
      it 'should be able to render radio buttons.' do
        statuses = [[1, 'Released'], [2, 'Pre Released'], [3, 'Closed']]
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.add_form(:status, :radio_buttons, statuses, :first, :last)
        elem = manager.forms[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.type?(:radio_buttons)).to be true
          num = 0
          elem.render(form) do |b|
            status = statuses[num]
            expect(b.label).to eq "<label for=\"shop_status_#{num + 1}\">#{status.last}</label>"
            expect(b.radio_button).to eq "<input type=\"radio\" value=\"#{status.first}\" name=\"shop[status]\" id=\"shop_status_#{num + 1}\" />"
            num += 1
          end
        end
      end
      it 'should be able to send options and html attributes to collection_radit_buttons.' do
        statuses = [[1, 'Released'], [2, 'Pre Released'], [3, 'Closed']]
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.add_form(
          :status,
          :radio_buttons,
          statuses,
          :first,
          :last,
          'Status', {
            disabled: [1, 2, 3]
          }, {
            class: 'foobar',
            style: 'font-size: 20px;'
          }
        )
        elem = manager.forms[0]
        helper.form_with model: shop, url: './create' do |form|
          num = 0
          elem.render(form) do |b|
            status = statuses[num]
            expect(b.radio_button).to eq(
              "<input style=\"font-size: 20px;\" class=\"foobar\" disabled=\"disabled\" type=\"radio\" value=\"#{status.first}\" name=\"shop[status]\" id=\"shop_status_#{num + 1}\" />"
            )
            num += 1
          end
        end
      end
    end
    context 'Select options' do
      it 'should be able to render select.' do
        FactoryBot.create_list(:category, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.add_form(:category_id, :select_options, Category.all, :id, :name)
        elem = manager.forms[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.type?(:select_options)).to be true
          result = elem.render(form).gsub!(/\R+/, '').gsub!(/></, ">\n<").split("\n")
          expect(result.shift).to eq '<select name="shop[category_id]">'
          expect(result.pop).to eq '</select>'
          num = 0
          result.each do |option|
            category = Category.all.offset(num).first
            if shop.category_id == category.id
              expect(option).to eq "<option selected=\"selected\" value=\"#{category.id}\">#{category.name}</option>"
            else
              expect(option).to eq "<option value=\"#{category.id}\">#{category.name}</option>"
            end
            num += 1
          end
        end
      end
      it 'should be able to send options and html attributes to collection_select.' do
        FactoryBot.create_list(:category, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.add_form(
          :category_id,
          :select_options,
          Category.all,
          :id,
          :name,
          'Category', {
            include_blank: 'Select Category'
          }, {
            class: 'foobar',
            style: 'width: 200px;'
          }
        )
        elem = manager.forms[0]
        helper.form_with model: shop, url: './create' do |form|
          result = elem.render(form).gsub!(/\R+/, '').gsub!(/></, ">\n<").split("\n")
          expect(result.shift).to eq '<select style="width: 200px;" class="foobar" name="shop[category_id]">'
          expect(result.shift).to eq '<option value="">Select Category</option>'
        end
      end
    end
  end
end
