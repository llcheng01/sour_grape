require 'airborne'
require_relative '../app/api/v1'
require 'pry'

Airborne.configure do |config|
  config.rack_app = API::V1
end

describe API::Products do
    context 'GET /api/v1/products' do
      it 'returns 200 response' do
        get "api/v1/products"
        expect_status(200)
      end

      it 'returns all products' do
        get '/api/v1/products'
        expect_json([])
      end
    end
end
