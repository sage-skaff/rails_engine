require 'rails_helper'

describe 'Items API' do
  it 'can get a list of all items' do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_an(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_an(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_an(Float)
    end
  end

  it 'returns one item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_an(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_an(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_an(Float)
  end

  it 'can create a new item' do
    id = create(:merchant).id

    item_params = {
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.sentence,
      unit_price: Faker::Commerce.price,
      merchant_id: id
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(created_item).to have_key(:id)
    expect(created_item[:id]).to be_an(String)

    expect(created_item[:attributes]).to have_key(:name)
    expect(created_item[:attributes][:name]).to be_an(String)

    expect(created_item[:attributes]).to have_key(:description)
    expect(created_item[:attributes][:description]).to be_an(String)

    expect(created_item[:attributes]).to have_key(:unit_price)
    expect(created_item[:attributes][:unit_price]).to be_an(Float)

    expect(created_item[:attributes]).to have_key(:merchant_id)
    expect(created_item[:attributes][:merchant_id]).to be_an(Integer)
  end
end