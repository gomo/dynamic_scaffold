require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context 'DynamicScaffold::Manager#editor.fields' do
    it 'should output all columns by default.' do
      manager = DynamicScaffold::Manager.new Country

      forms = manager.editor.form_fields
      expect(forms.size).to eq Country.column_names.size

      country = FactoryBot.create(:country)
      helper.form_with model: country, url: './create' do |form|
        expect(forms[0].label).to eq 'Id'
        expect(forms[0].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.id}\" name=\"country[id]\" />"
        )

        expect(forms[1].label).to eq 'Name'
        expect(forms[1].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.name}\" name=\"country[name]\" />"
        )

        expect(forms[2].label).to eq 'Sequence'
        expect(forms[2].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.sequence}\" name=\"country[sequence]\" />"
        )

        expect(forms[3].label).to eq 'Created at'
        expect(forms[3].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.created_at}\" name=\"country[created_at]\" />"
        )

        expect(forms[4].label).to eq 'Updated at'
        expect(forms[4].render(form)).to(
          eq "<input type=\"text\" value=\"#{country.updated_at}\" name=\"country[updated_at]\" />"
        )
      end
    end
  end
  context 'DynamicScaffold::Manager::Editor::FormField' do
    context 'Simple' do
      it 'should be able to specify a label.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.editor.text_field(:id).label('FOOBAR')
        elem = manager.editor.form_fields[0]
        helper.form_with model: country, url: './create' do |form|
          expect(elem.label).to eq 'FOOBAR'
        end
      end

      it 'should use the column name for the label if you omit it.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.editor.text_field(:id)
        elem = manager.editor.form_fields[0]
        helper.form_with model: country, url: './create' do |form|
          expect(elem.label).to eq 'Id'
        end
      end

      it 'should be able to generate HTML attributes with the last hash argument.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.editor.text_field(
          :id,
          class: 'foobar',
          'data-foobar' => 'foobar value',
          style: 'width: 50%;'
        )
        elem = manager.editor.form_fields[0]
        helper.form_with model: country, url: './create' do |form|
          expect(elem.render(form)).to(
            eq "<input data-foobar=\"foobar value\" style=\"width: 50%;\" class=\"foobar\" type=\"text\" value=\"#{country.id}\" name=\"country[id]\" />"
          )
        end
      end

      it 'should be able to add class attributes with the last argument of render.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.editor.text_field(
          :id,
          class: 'foobar'
        )
        elem = manager.editor.form_fields[0]
        helper.form_with model: country, url: './create' do |form|
          expect(elem.render(form, 'add')).to(
            eq "<input class=\"foobar add\" type=\"text\" value=\"#{country.id}\" name=\"country[id]\" />"
          )
        end
      end

      it 'should be able to add notes in the note method.' do
        country = FactoryBot.create(:country)
        manager = DynamicScaffold::Manager.new Country
        manager.editor.text_field(:id).note do
          content_tag(:p, 'foo')
        end.note do
          content_tag(:p, 'bar')
        end
        elem = manager.editor.form_fields[0]
        helper.form_with model: country, url: './create' do |form|
          expect(elem.render_notes(country, helper)).to eq '<p>foo</p><p>bar</p>'
        end
      end
    end
    context 'CollectionCheckBoxes' do
      it 'should be able to render check boxes.' do
        FactoryBot.create_list(:state, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.editor.collection_check_boxes(:states, State.all, :id, :name)
        elem = manager.editor.form_fields[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.type?(:collection_check_boxes)).to be true
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
        manager.editor.collection_check_boxes(:states, State.all, :id, :name).label('State')
        elem = manager.editor.form_fields[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.label).to eq 'State'
        end
      end
      it 'should use the column name for the label if you omit it.' do
        FactoryBot.create_list(:state, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.editor.collection_check_boxes(:states, State.all, :id, :name)
        elem = manager.editor.form_fields[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.label).to eq 'States'
        end
      end
      it 'should be able to send options and html attributes to collection_check_boxes.' do
        FactoryBot.create_list(:state, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.editor.collection_check_boxes(
          :states,
          State.all,
          :id,
          :name, {
            disabled: State.all.map(&:id)
          }, {
            class: 'foobar',
            style: 'font-size: 20px;'
          }
        )
        elem = manager.editor.form_fields[0]
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
    context 'CollectionRadioButtons' do
      it 'should be able to render radio buttons.' do
        statuses = [[1, 'Released'], [2, 'Pre Released'], [3, 'Closed']]
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.editor.collection_radio_buttons(:status, statuses, :first, :last)
        elem = manager.editor.form_fields[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.type?(:collection_radio_buttons)).to be true
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
        manager.editor.collection_radio_buttons(
          :status,
          statuses,
          :first,
          :last, {
            disabled: [1, 2, 3]
          }, {
            class: 'foobar',
            style: 'font-size: 20px;'
          }
        )
        elem = manager.editor.form_fields[0]
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
    context 'CollectionSelect' do
      it 'should be able to render select.' do
        FactoryBot.create_list(:category, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.editor.collection_select(:category_id, Category.all, :id, :name)
        elem = manager.editor.form_fields[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.type?(:collection_select)).to be true
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
        manager.editor.collection_select(
          :category_id,
          Category.all,
          :id,
          :name, {
            include_blank: 'Select Category'
          }, {
            class: 'foobar',
            style: 'width: 200px;'
          }
        )
        elem = manager.editor.form_fields[0]
        helper.form_with model: shop, url: './create' do |form|
          result = elem.render(form).gsub!(/\R+/, '').gsub!(/></, ">\n<").split("\n")
          expect(result.shift).to eq '<select style="width: 200px;" class="foobar" name="shop[category_id]">'
          expect(result.shift).to eq '<option value="">Select Category</option>'
        end
      end
    end
    context 'GroupedCollectionSelect' do
      it 'should be able to render select with optgroup.' do
        grouped_options = [[
          'Group 1',
          [[1, 'Item 1'], [2, 'Item 2'], [3, 'Item 3']]
        ], [
          'Group 2',
          [[4, 'Item 4'], [5, 'Item 5'], [6, 'Item 6']]
        ]]
        FactoryBot.create_list(:category, 3)
        shop = FactoryBot.create(:shop)
        manager = DynamicScaffold::Manager.new Shop
        manager.editor.grouped_collection_select(:category_id, grouped_options, :last, :first, :first, :last)
        elem = manager.editor.form_fields[0]
        helper.form_with model: shop, url: './create' do |form|
          expect(elem.type?(:grouped_collection_select)).to be true
          result = elem.render(form).gsub!(/\R+/, '').gsub!(/></, ">\n<").split("\n")
          option_checker = proc do |value, name|
            if shop.category_id == value
              expect(result.shift).to eq "<option selected=\"selected\" value=\"#{value}\">#{name}</option>"
            else
              expect(result.shift).to eq "<option value=\"#{value}\">#{name}</option>"
            end
          end

          expect(result.shift).to eq '<select name="shop[category_id]">'
          expect(result.shift).to eq '<optgroup label="Group 1">'
          grouped_options.first.last.each do |op|
            value = op.first
            name = op.last
            option_checker.call(value, name)
          end
          expect(result.shift).to eq '</optgroup>'
          expect(result.shift).to eq '<optgroup label="Group 2">'
          grouped_options.second.last.each do |op|
            value = op.first
            name = op.last
            option_checker.call(value, name)
          end
          expect(result.shift).to eq '</optgroup>'
          expect(result.shift).to eq '</select>'
          expect(result.empty?).to be true
        end
      end
    end
  end
end
