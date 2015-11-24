module V1
  class ChecklistsController < BaseController
    before_action :set_current_user_checklists, except: :create
    before_action :get_checklist, except: [:index, :create]

    resource_description do
      short "Managing Checklist"
    end

    api :GET, '/v1/checklists', 'List checklists'
    description <<-EOS
      == Retrieve Checklists
       This endpoint is used to retrieve a users' checklists. It optionally takes params to return the checklist in pages and the for limit of checklists to fetch per request. It could also be queried with a search params to return all checklists that match the params.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :limit, Integer, allow_nil: true, desc: "Number of checklist pre-request"
    param :page, Integer, allow_nil: true, desc: "Item page"
    param :q, String, allow_nil: true, desc: "Search params for a checklist"
    error code: 401, desc: "Unauthorized. Invalid token."
    def index
      checklists = @my_checklists
      q = params[:q]
      checklists = q ? checklists.where("name Like ?", "%#{q}%") : checklists.all

      paginate = PaginationManager.new(params, checklists)
      render json: paginate.query, meta: paginate.set_meta_tag, status: 200
    end

    api :POST, '/v1/checklists', 'Create a checklist'
    description <<-EOS
      == Create new Checklist
       This endpoint is used to create a new checklist. It requires a name for the new checklist.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :checklist, Hash do
      param :name, String, required: true, desc: "Name for the new checklist."
    end
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    def create
      checklist = Checklist.new(checklist_params)
      checklist.user = current_user
      if checklist.save
        render json: checklist, status: 201#, location: checklist
      else
        render json: checklist.errors.full_messages, status: 422
      end
    end

    api :GET, '/v1/checklists/:id', 'Show a checklist'
    description <<-EOS
      == Show details of a Checklist
       This endpoint is used to retrieve more details of a given checklist such as created_at. It requires a valid user checklist id
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :id, Integer, required: true, desc: "Id of the user checklist to fetch."
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    def show
      render json: @checklist, status: 200
    end

    api :PATCH, '/v1/checklists/:id', 'Update a checklist'
    api :PUT, '/v1/checklists/:id', 'Update a checklist'
    description <<-EOS
      == Update a Checklist
       This endpoint is used to update the details of a given checklist. It requires a valid user checklist id and new name for the checklist.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    param :checklist, Hash do
      param :name, String, desc: "New name for the checklist", required: true
    end
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    def update
      data = checklist_params
      if data.empty?
        render json: @checklist, status: 422
      else
        if @checklist.update(data)
          render json: @checklist, status: 200
        else
          render json: @checklist.errors.full_messages, status: 422
        end
      end
    end

    api :DELETE, '/v1/checklists/:id', 'Destroy a checklist'
    description <<-EOS
      == Destroy a Checklist
       This endpoint is used to delete a checklist and all it's associated items.
      === Authentication required
       Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
    EOS
    formats ["json"]
    error code: 401, desc: "Unauthorized. Invalid token."
    error code: 422, desc: "Invalid parameter sent"
    def destroy
      @checklist.destroy
      head 204
    end

    private

    def checklist_params
      params.fetch(:checklist, {}).permit(:name)
    end
  end
end
