module GrapeExampleApp
  class V1 < Grape::API
    version 'v1', using: :path, vendor: 'grape_example_app'
    content_type :json, 'application/json; charset=UTF-8'
    prefix :api
    format :json
  end
end
