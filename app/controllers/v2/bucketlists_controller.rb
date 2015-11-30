module V2
  class BucketlistsController < BaseController
    include V2::ExtraFeatures
    before_action :get_bucketlist, except: [:index, :create]

    resource_description do
      short "Managing Bucketlist"
    end

    api :GET, '/v2/bucketlists', 'List bucketlists'
    description <<-EOS
      == Retrieve Bucketlists
       This endpoint is used to retrieve all bucketlists. It optionally takes params to return the bucketlist in pages and the limit of bucketlists to fetch per request. It could also be queried with an ownership params (o) to return all bucketlists that match the params or with keywords "mine" (returns only your bucketlists) or "not_mine" (returns bucketlists that are not yours)
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :limit, Integer, allow_nil: true, desc: "Number of bucketlist pre-request"
    param :page, Integer, allow_nil: true, desc: "Item page"
    param :q, String, allow_nil: true, desc: "Search params for a bucketlist"
    param :o, String, allow_nil: true, desc: "ownership params for a bucketlist. Can be 'user' or 'not_user'"
    error code: 401, desc: "Unauthorized. Invalid token."
    def index
      bucketlists = process_bucketlist(params)
      paginate = PaginationManager.new(params, bucketlists)
      render json: paginate.query, meta: paginate.set_meta_tag, status: 200
    end

    api :GET, '/v2/bucketlists/:id', 'Show a bucketlist'
    description <<-EOS
      == Show details of a Bucketlist
       This endpoint is used to retrieve more details of a given bucketlist such as created_at. It requires a valid user bucketlist id
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :id, Integer, required: true, desc: "Id of the user bucketlist to fetch."
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 404, desc: "Bucketlist not found."
    def show
      render json: @bucketlist, status: 200
    end

  end
end
