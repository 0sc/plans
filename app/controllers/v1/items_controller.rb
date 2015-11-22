module V1
  class ItemsController < BaseController
    before_action :set_current_user_checklists
    before_action { get_checklist(:id, params[:checklist_id]) }
    before_action :get_checklist_item, only: [:show, :destroy, :update]

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

    def create
      item = @checklist.items.new(item_params)
      if item.save
        render json: item, status: 201#, location: item
      else
        render json: item.errors.full_messages, status: 422
      end
    end

    def show
      render json: @item
    end

    def destroy
      @item.destroy
      head 204
    end

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
