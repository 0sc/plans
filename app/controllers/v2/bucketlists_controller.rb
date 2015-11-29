module V2
  class BucketlistsController < BaseController
    include V2::ExtraFeatures
    before_action :get_bucketlist, except: [:index, :create]

    def index
      bucketlists = process_bucketlist(params)
      paginate = PaginationManager.new(params, bucketlists)
      render json: paginate.query, meta: paginate.set_meta_tag, status: 200
    end

    def show
      render json: @bucketlist, status: 200
    end

  end
end
