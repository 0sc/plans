module V1
  class ItemsController < BaseController
    before_action :set_current_user_bucketlists
    before_action { get_bucketlist(:id, params[:bucketlist_id]) }
    before_action :get_bucketlist_item, only: [:show, :destroy, :update]

    def index
      if params[:status]
        process_item_status_check(params)
      else
        paginate = PaginationManager.new(params, @bucketlist.items)
        render json: paginate.query, status: 200
      end
    end

    def create
      process_create_query(@bucketlist.items.new(item_params))
    end

    def show
      render json: @item, status: 200
    end

    def destroy
      @item.destroy
      head 204
    end

    def update
      process_update_query(@item, item_params)
    end

    private

    def item_params
      params.fetch(:item, {}).permit(:name, :done)
    end
  end
end
