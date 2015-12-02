module ProcessingUtilities
  def process_update_query(target, payload)
    if payload.empty?
      render json: target, status: 400
    else
      if target.update(payload)
        render json: target, status: 200
      else
        render json: target.errors.full_messages, status: 422
      end
    end
  end

  def process_create_query(package)
    if package.save
      render json: package, status: 201 # location: bucketlist
    else
      render json: package.errors.full_messages, status: 422
    end
  end

  def process_item_status_check(params)
    action = {
      "done" => @bucketlist.completed,
      "pending" => @bucketlist.pending
    }
    type = action[params[:status]]
    if type
      paginate = PaginationManager.new(params, type)
      render json: paginate.query, status: 200
    else
      head 422, content_type: "application/json"
    end
  end

  def get_bucketlist_item
    @item = @bucketlist.items.find_by(id: params[:id])
    head 404, content_type: "application/json" unless @item
  end
end
