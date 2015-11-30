module V2
  class ItemsController < BaseController
    before_action { get_bucketlist(:id, params[:bucketlist_id]) }
    before_action :get_bucketlist_item, only: [:show, :destroy, :update]

    resource_description do
      short "Managing Checklist Items"
    end

    api :GET, '/v2/checklists/:checklist_id/items', 'List items'
    description <<-EOS
      == Retrieve items
       This endpoint is used to retrieve the items in a given checklist. It optionally takes params to return the items in pages and the limit of items to fetch per request. If not provided it defaults to 20 items per query. The max allowed number of items that can be fetched per request is 100. It could also be queried with a status params (i.e 'done' or 'pending') to return all items that match the params.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :checklist_id, Integer, required: true, desc: "Id of the checklist item belongs to"
    param :limit, Integer, allow_nil: true, desc: "Number of items pre-request"
    param :page, Integer, allow_nil: true, desc: "Item page"
    param :status, String, allow_nil: true, desc: "Item status: 'done' or 'pending'"
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    error code: 404, desc: "Specified bucketlist not found."
    def index
      if params[:status]
        process_item_status_check(params)
      else
        paginate = PaginationManager.new(params, @bucketlist.items)
        render json: paginate.query, status: 200
      end
    end

    api :GET, '/v2/checklists/:checklist_id/items/:id', 'Show an item'
    description <<-EOS
      == Show details of an Item
       This endpoint is used to retrieve more details of a given item such as created_at, completed status. It requires a valid checklist id and item id
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :checklist_id, Integer, required: true, desc: "Id of the checklist item belongs to"
    param :id, Integer, required: true, desc: "Item id"
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 404, desc: "Item not found."
    error code: 404, desc: "Specified bucketlist not found."
    def show
      render json: @item, status: 200
    end
  end
end
