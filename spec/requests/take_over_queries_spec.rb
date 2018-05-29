require "rails_helper"

RSpec.describe "Take over queries", :type => :request do
  example "delete" do
    country = FactoryBot.create(:country)
    delete "/en/request/countries/#{country.id}?foo=bar&page=1"
    expect(response).to redirect_to('/en/request/countries?foo=bar&page=1')
  end

  example "sort" do
    countries = FactoryBot.create_list(:country, 2)
    countries = Country.all.order sequence: :desc

    pkeys = []
    pkeys << { id: countries[1].id }
    pkeys << { id: countries[0].id }
    patch '/en/request/countries/sort?foo=bar&page=1', params: { locale: :en, pkeys: pkeys, submit_sort: '' }
    expect(response).to redirect_to('/en/request/countries?foo=bar&page=1')
  end

  example "list page" do
    country = FactoryBot.create(:country)
    get "/en/request/countries?foo=bar&page=1"
    doc = Nokogiri::HTML(response.body)

    # form
    expect(doc.css('form').first.attribute('action').value).to eq('/en/request/countries/sort?foo=bar')

    # edit link
    expect(doc.css('.resplist-row .edit').first.attribute('href').value).to eq('/en/request/countries/1/edit?foo=bar&page=1')

    # delete button
    expect(doc.css('.resplist-row .dynamicScaffoldJs-destory').first.attribute('data-action').value).to eq('/en/request/countries/1?foo=bar')
  end

  example "edit page" do
    country = FactoryBot.create(:country)
    get "/en/request/countries/#{country.id}/edit?foo=bar&page=1"
    doc = Nokogiri::HTML(response.body)

    # form
    expect(doc.css('form').first.attribute('action').value).to eq("/en/request/countries/#{country.id}?foo=bar&page=1")

    # back button
    expect(doc.css('.back').first.attribute('href').value).to eq('/en/request/countries?foo=bar&page=1')


    patch "/en/request/countries/#{country.id}?foo=bar&page=1", params: { country: {name: 'aaaa'} }
    expect(response).to redirect_to('/en/request/countries?foo=bar&page=1')
  end

  example "new page" do
    post "/en/request/countries?foo=bar&page=1", params: { country: {name: 'aaaa'} }
    expect(response).to redirect_to('/en/request/countries?foo=bar&page=1')
  end
end