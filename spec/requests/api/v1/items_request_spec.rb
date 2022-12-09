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
      name: 'Widget',
      description: 'High quality widget',
      unit_price: 100.99,
      merchant_id: id
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'returns an error if any attribute is missing when trying to create an item' do
    id = create(:merchant).id

    item_params = {
      name: 'Widget',
      description: 'High quality widget',
      merchant_id: id
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    expect(response).to have_http_status(422)
  end

  it 'can update an existing item' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: 'New Widget Name' }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('New Widget Name')
  end

  it 'can destroy an existing item' do
    id = create(:item).id

    expect { delete "/api/v1/items/#{id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(response).to have_http_status(204)
  end

  it 'returns all merchant data associated with an item' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant2)

    get "/api/v1/items/#{item1.id}/merchant"

    expect(response).to be_successful

    item1_merchant = JSON.parse(response.body, symbolize_names: true)
    expect(item1_merchant[:data]).to have_key(:id)
    expect(item1_merchant[:data][:id]).to be_an(String)

    expect(item1_merchant[:data][:attributes]).to have_key(:name)
    expect(item1_merchant[:data][:attributes][:name]).to be_an(String)
    expect(item1_merchant[:data][:attributes][:name]).to eq(merchant1.name)
  end

  it 'returns an error status if item id does not exist' do
    get '/api/v1/items/8923987297/merchant'

    expect(response).to have_http_status(404)
  end

  it 'returns an error status if string instead of integer' do
    get '/api/v1/items/string-instead-of-integer/merchant'

    expect(response).to have_http_status(404)
  end
end
