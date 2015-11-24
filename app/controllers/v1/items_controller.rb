module V1
  class ItemsController < BaseController
    before_action :set_current_user_checklists
    before_action { get_checklist(:id, params[:checklist_id]) }
    before_action :get_checklist_item, only: [:show, :destroy, :update]

    resource_description do
      short "Managing Checklist Items"
    end

    api :GET, '/v1/checklists/:checklist_id/items', 'List items'
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
    def index
      if params[:status]
        q = params[:status]
        if q == "done"
          paginate = PaginationManager.new(params, @checklist.completed)
          render json: paginate.query, status: 200
        elsif q == "pending"
          paginate = PaginationManager.new(params, @checklist.pending)
          render json: paginate.query, status: 200
        else
          render json: "", status: 422
        end
      else
        paginate = PaginationManager.new(params, @checklist.items)
        render json: paginate.query, status: 200
      end
    end

    api :POST, '/v1/checklists/:checklist_id/items', 'Create an item'
    description <<-EOS
      == Create new Item
       This endpoint is used to create a new item in the given checklist. It requires a name for the new item. Optionally, you can specify whether the item has been completed (true) or not (false).
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :checklist_id, Integer, required: true, desc: "Id of the checklist item belongs to"
    param :item, Hash, description: "Checklist item description" do
      param :name, String, required: true, desc: "Item name"
      param :done, :bool, allow_nil: true, desc: "Status of the item. Has it been completed? 'true' or 'false'"
    end
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    def create
      item = @checklist.items.new(item_params)
      if item.save
        render json: item, status: 201#, location: item
      else
        render json: item.errors.full_messages, status: 422
      end
    end

    api :GET, '/v1/checklists/:checklist_id/items/:id', 'Show an item'
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
    error code: 422, desc: "Invalid parameter sent"
    def show
      render json: @item
    end

    api :DELETE, '/v1/checklists/:checklist_id/items/:id', 'Destroy an item'
    description <<-EOS
      == Destroy an item
       This endpoint is used to delete a checklist item.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :checklist_id, Integer, required: true, desc: "Id of the checklist item belongs to"
    param :id, Integer, required: true, desc: "Item id"
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    def destroy
      @item.destroy
      head 204
    end

    api :PATCH, '/v1/checklists/:checklist_id/items/:id', 'Update an item'
    api :PUT, '/v1/checklists/:checklist_id/items/:id', 'Update an item'
    description <<-EOS
      == Update an Item
       This endpoint is used to update the details of a given checklist item. It requires a valid checklist id and new name (and 'done' status) for the item.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :checklist_id, Integer, required: true, desc: "Id of the checklist item belongs to"
    param :id, Integer, required: true, desc: "Item id"
    param :item, Hash do
      param :done, :bool, allow_nil: true, desc: "Item completed? 'true' : 'false'"
      param :name, String, allow_nil: true, desc: "New name for the checklist item."
    end
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    def update
      if item_params.empty?
        render json: @item, status: 422
      else
        if @item.update(item_params)
          render json: @item, status: 200
        else
          render json: @item.errors.full_messages, status: 422
        end
      end
    end

    private

    def get_checklist_item
      @item = @checklist.items.find_by(id: params[:id])
      render json: "", status: 422 unless @item
    end

    def item_params
      params.fetch(:item, {}).permit(:name, :done)
    end
  end
end
