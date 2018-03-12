require 'rails_helper'
RSpec.describe SpecsController, type: :controller do
  delegate :dynamic_scaffold, to: :controller
  describe 'Order' do
    example 'ASC' do
      FactoryBot.create_list(:shop, 5)
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.list.order(id: :asc)
      end

      get :index, params: { locale: :en }

      records = assigns(:records)
      (1..5).each.with_index do |id, index|
        expect(records[index].id).to eq id
      end
    end

    example 'DESC' do
      FactoryBot.create_list(:shop, 5)
      controller.class.send(:dynamic_scaffold, Shop) do |c|
        c.list.order(id: :desc)
      end

      get :index, params: { locale: :en }

      records = assigns(:records)
      5.downto(1).each.with_index do |id, index|
        expect(records[index].id).to eq id
      end
    end
  end
end
