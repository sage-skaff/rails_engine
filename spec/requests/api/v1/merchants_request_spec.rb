require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  it 'returns one merchant by their id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_an(String)
  end

  it 'returns all items associated with a merchant' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant1)
    item3 = create(:item, merchant: merchant2)

    get "/api/v1/merchants/#{merchant1.id}/items"

    expect(response).to be_successful

    merchant1_items = JSON.parse(response.body, symbolize_names: true)
    expect(merchant1_items[:data][0][:attributes][:merchant_id]).to eq(1)
    expect(merchant1_items[:data][1][:attributes][:merchant_id]).to eq(1)
  end

  it 'returns an error status if merchant id does not exist' do
    get '/api/v1/merchants/8923987297/items'

    expect(response).to have_http_status(404)
  end
end
