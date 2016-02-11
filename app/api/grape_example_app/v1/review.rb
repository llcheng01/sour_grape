module GrapeExampleApp
  class V1::Review < Grape::API
    use Rack::JSONP

    helpers do
      params :token do
        optional :token, type: String, default: nil
      end

      params :attributes do
        optional :attributes, type: Hash, default: {}
      end
    end

    resource :reviews do
        # get
        get do
            api_response(::Review.all.to_json)
        end

        # get by id
        route_param :id do
            params do
                use :token, type: String, desc: 'Authentication token'
                requires :id, type: Integer, desc: "Review ID"
            end
            get do
                begin
                  authenticate!

                  review = ::Review.find(params[:id])
                  api_response(review.to_json)
                rescue ActiveRecord::RecordNotFound => e
                    status 404 # Not found
                end
            end
        end

        # POST review
        params do
            use :token
            requires :attributes, type: Hash, desc: 'Review object to create' do
              requires :title, type: String, desc: 'Title of review'
              requires :body, type: String, desc: 'Body of review'
            end
        end
        post do
            begin
                authenticate!
                safe_params = clean_params(params[:attributes]).permit(:title, :body)

                if safe_params
                  ::Review.create!(safe_params)
                  status 200 # Saved OK
                end
            rescue ActiveRecord::RecordNotFound => e
                status 404 # Not found
            end
        end
        # PUT review by id
        params do
            use :token, type: String, desc: 'Authentication token'
            requires :id, type: Integer, desc: "Review ID"
            requires :attributes, type: Hash, desc: 'Review object to create' do
              requires :title, type: String, desc: 'Title of review'
              requires :body, type: String, desc: 'Body of review'
            end
        end
        put ':id' do
            begin
              authenticate!
              safe_params = clean_params(params[:attributes]).permit(:title, :body)

              if safe_params
                review = ::Review.find(params[:id])
                review.update_attributes(safe_params)
                status 200 # Saved OK
              end
            rescue ActiveRecord::RecordNotFound => e
              status 404 # Not found
            end
        end
    # end of resource
    end
  end
end
