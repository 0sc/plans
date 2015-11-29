module V2
  module ExtraFeatures
    def process_bucketlist(params)
      bucketlist = set_ownership(params[:o])
      q = params[:q]
      q ? bucketlist.search(q) : bucketlist
    end

    def set_ownership(owner)
      if owner == "user"
        return current_user.bucketlists
      elsif owner == "not_user"
        return Bucketlist.not_mine(current_user)
      else
        return Bucketlist.all
      end
    end
  end
end
