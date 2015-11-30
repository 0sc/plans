module V1
  class BucketlistsController < BaseController
    before_action :set_current_user_bucketlists, except: :create
    before_action :get_bucketlist, except: [:index, :create]

    resource_description do
      short "Managing Bucketlist"
    end

    api :GET, '/v1/bucketlists', 'List bucketlists'
    description <<-EOS
      == Retrieve Bucketlists
       This endpoint is used to retrieve a users' bucketlists. It optionally takes params to return the bucketlist in pages and the limit of bucketlists to fetch per request. It could also be queried with a search params to return all bucketlists that match the params.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :limit, Integer, allow_nil: true, desc: "Number of bucketlist pre-request"
    param :page, Integer, allow_nil: true, desc: "Item page"
    param :q, String, allow_nil: true, desc: "Search params for a bucketlist"
    error code: 401, desc: "Unauthorized. Invalid token."
    def index
      bucketlists = @my_bucketlists
      q = params[:q]
      bucketlists = q ? bucketlists.search(q) : bucketlists.all

      paginate = PaginationManager.new(params, bucketlists)
      render json: paginate.query, meta: paginate.set_meta_tag, status: 200
    end

    api :POST, '/v1/bucketlists', 'Create a bucketlist'
    description <<-EOS
      == Create new Bucketlist
       This endpoint is used to create a new bucketlist. It requires a name for the new bucketlist.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :bucketlist, Hash do
      param :name, String, required: true, desc: "Name for the new bucketlist."
    end
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    def create
      bucketlist = Bucketlist.new(bucketlist_params)
      bucketlist.user = current_user
      process_create_query(bucketlist)
    end

    api :GET, '/v1/bucketlists/:id', 'Show a bucketlist'
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

    api :PATCH, '/v1/bucketlists/:id', 'Update a bucketlist'
    api :PUT, '/v1/bucketlists/:id', 'Update a bucketlist'
    description <<-EOS
      == Update a Bucketlist
       This endpoint is used to update the details of a given bucketlist. It requires a valid user bucketlist id and new name for the bucketlist.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :bucketlist, Hash do
      param :name, String, desc: "New name for the bucketlist", required: true
    end
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    error code: 400, desc: "Empty request params."
    error code: 404, desc: "Bucketlist not found."
    def update
      process_update_query(@bucketlist, bucketlist_params)
    end

    api :DELETE, '/v1/bucketlists/:id', 'Destroy a bucketlist'
    description <<-EOS
      == Destroy a Bucketlist
       This endpoint is used to delete a bucketlist and all it's associated items.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 404, desc: "Bucketlist not found."
    def destroy
      @bucketlist.destroy
      head 204
    end

    private

    def bucketlist_params
      params.fetch(:bucketlist, {}).permit(:name)
    end
  end
end
