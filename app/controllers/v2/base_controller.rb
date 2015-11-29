module V2
  class BaseController < ApplicationController
    before_action :authenticate_token

    def get_bucketlist(col = :id, data = params[:id] )
      @bucketlist = Bucketlist.find_by(col => data)
      head 404, content_type: "application/json" unless @bucketlist
    end
  end
end
