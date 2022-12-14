require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "index by page" do
    it "works!" do
      17.times do
        Item.create amount: 5
      end
      expect(Item.count).to eq(17)
      get '/api/v1/items'
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(10)
      get '/api/v1/items?page=2'
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(7)
    end
  end
  describe 'create' do
    it "can create an item" do
      expect {
        post '/api/v1/items', params: {amount: 5, notes: '124'}
      }.to change {Item.count}.by(+1)
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resource']['amount']).to eq(5)
      expect(json['resource']['notes']).to eq('124')
    end
  end
end
