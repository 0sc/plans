module V1
  class ItemsController < BaseController
    before_action :set_current_user_checklists
    before_action { get_checklist(:id, params[:checklist_id]) }
    before_action :get_checklist_item, only: [:show, :destroy, :update]

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :GET, '/v1/checklists/:checklist_id/items', 'List items'
    param :limit, :undef, allow_nil: true
    param :page, :undef, allow_nil: true
    param :q, :undef, allow_nil: true
    error code: 401
    error code: 422
    def index
      if params[:q]
        q = params[:q]
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

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :POST, '/v1/checklists/:checklist_id/items', 'Create an item'
    param :item, Hash do
      param :name, :undef
    end
    error code: 401
    error code: 422
    def create
      item = @checklist.items.new(item_params)
      if item.save
        render json: item, status: 201#, location: item
      else
        render json: item.errors.full_messages, status: 422
      end
    end

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :GET, '/v1/checklists/:checklist_id/items/:id', 'Show an item'
    error code: 401
    error code: 422
    def show
      render json: @item
    end

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :DELETE, '/v1/checklists/:checklist_id/items/:id', 'Destroy an item'
    error code: 401
    error code: 422
    def destroy
      @item.destroy
      head 204
    end

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :PATCH, '/v1/checklists/:checklist_id/items/:id', 'Update an item'
    api :PUT, '/v1/checklists/:checklist_id/items/:id', 'Update an item'
    param :done, :bool
    param :item, Hash do
      param :done, :bool
      param :name, :undef
    end
    param :name, :undef
    error code: 401
    error code: 422
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
