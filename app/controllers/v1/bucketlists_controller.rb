module V1
  class BucketlistsController < BaseController
    before_action :set_current_user_bucketlists, except: :create
    before_action :get_bucketlist, except: [:index, :create]

    def index
      bucketlists = @my_bucketlists
      q = params[:q]
      bucketlists = q ? bucketlists.search(q) : bucketlists.all

      paginate = PaginationManager.new(params, bucketlists)
      render json: paginate.query, meta: paginate.set_meta_tag, status: 200
    end

    def create
      bucketlist = Bucketlist.new(bucketlist_params)
      bucketlist.user = current_user
      process_create_query(bucketlist)
    end

    def show
      render json: @bucketlist, status: 200
    end

    def update
      process_update_query(@bucketlist, bucketlist_params)
    end

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
