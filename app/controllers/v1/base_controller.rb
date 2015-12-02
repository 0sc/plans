module V1
  class BaseController < ApplicationController
    before_action :authenticate_token

    def set_current_user_bucketlists
      @my_bucketlists = current_user.bucketlists
    end

    def get_bucketlist(col = :id, data = params[:id])
      @bucketlist = @my_bucketlists.find_by(col => data)
      head 404, content_type: "application/json" unless @bucketlist
    end
  end
end
