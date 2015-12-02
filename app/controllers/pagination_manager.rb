class PaginationManager
  attr_reader :limit, :page, :offset, :query_object, :size

  def initialize(params, query_object)
    pagination_params(params)
    @query_object = query_object
    @size = query_object.count
  end

  def query
    query_object.limit(limit).offset(offset)
  end

  def pagination_params(p)
    @page = get_page_params(p[:page])
    @limit = get_limit_params(p[:limit])
    @offset = (page - 1) * limit
  end

  def get_page_params(p)
    p ||= 1
    p = p.to_i
    p > 0 ? p : 1
  end

  def get_limit_params(p)
    p ||= 20
    p = p.to_i
    p.between?(1, 100) ? p : 100
  end

  # methods for setting meta tags

  def set_total_pages
    limit > size ? 1 : (size / limit).ceil
  end

  def set_limit
    limit > size ? size : limit
  end

  def set_meta_tag
    {
      pagination: {
        current_page: page,
        per_page: set_limit,
        total_pages: set_total_pages
      }
    }
  end
end
