module V2
  class ItemsController < BaseController
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

    def show
      render json: @item, status: 200
    end
  end
end
