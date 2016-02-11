module GrapeExampleApp
  class V1::Product < Grape::API
    use Rack::JSONP

    helpers do
      params :token do
        optional :token, type: String, default: nil
      end

      params :attributes do
        optional :attributes, type: Hash, default: {}
      end
    end

    resource :products do
      # /products
      get do
        api_response(::Product.all.to_json)
      end

      # /product/:id
      route_param :id do
        params do
          use :token, type: String, desc: 'Authentication token'
          requires :id, type: Integer, desc: "Product ID"
        end
        get do
          begin
            authenticate!

            product = ::Product.find(params[:id])
            api_response(product.to_json)
          rescue ActiveRecord::RecordNotFound => e
            status 404 # Not Found
          end
        end
      end

      # POST /products {:attributes}
      params do
        use :token
        requires :attributes, type: Hash, desc: 'Product object to create' do
          requires :name, type: String, desc: 'Name of product'
          requires :description, type: String, desc: 'Description of product'
          requires :image_url, type: String, desc: 'URL of image for product'
          requires :price, type: Integer, desc: 'Price of product'
          requires :stock, type: Integer, desc: 'Stock of product'
        end
      end
      post do
        begin
            authenticate!
            safe_params = clean_params(params[:attributes])
                            .permit(:name, :description, :image_url, :price, :stock)
    
            if safe_params
                ::Product.create!(safe_params)
                status 200 # Saved OK
            end
        rescue ActiveRecord::RecordNotFound => e
            status 404 # Not Found
        end
      end

      # PUT /product {:attributes}
      params do
        use :token, type: String, desc: 'Authentication token'
        requires :id, type: Integer, desc: "Product ID"
        requires :attributes, type: Hash, desc: 'Product object to create' do
          requires :name, type: String, desc: 'Name of product'
          requires :description, type: String, desc: 'Description of product'
          requires :image_url, type: String, desc: 'URL of image for product'
          requires :price, type: Integer, desc: 'Price of product'
          requires :stock, type: Integer, desc: 'Stock of product'
        end
      end
      put ':id' do
        begin
          authenticate!
          safe_params = clean_params(params[:attributes]).permit(:name, :description, :image_url, :price, :stock)

          if safe_params
            product = ::Product.find(params[:id])
            product.update_attributes(safe_params)
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
