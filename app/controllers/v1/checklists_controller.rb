module V1
  class ChecklistsController < BaseController
    before_action :set_current_user_checklists, except: :create
    before_action :get_checklist, except: [:index, :create]

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :GET, '/v1/checklists', 'List checklists'
    param :limit, :undef, allow_nil: true
    param :page, :undef, allow_nil: true
    param :q, :undef, allow_nil: true
    error code: 401
    def index
      checklists = @my_checklists
      q = params[:q]
      checklists = q ? checklists.where("name Like ?", "%#{q}%") : checklists.all

      paginate = PaginationManager.new(params, checklists)
      render json: paginate.query, meta: paginate.set_meta_tag, status: 200
    end

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :POST, '/v1/checklists', 'Create a checklist'
    param :checklist, Hash do
      param :name, :undef
    end
    error code: 401
    error code: 422
    def create
      checklist = Checklist.new(checklist_params)
      checklist.user = current_user
      if checklist.save
        render json: checklist, status: 201#, location: checklist
      else
        render json: checklist.errors.full_messages, status: 422
      end
    end

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :GET, '/v1/checklists/:id', 'Show a checklist'
    error code: 401
    error code: 422
    def show
      render json: @checklist, status: 200
    end

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :PATCH, '/v1/checklists/:id', 'Update a checklist'
    api :PUT, '/v1/checklists/:id', 'Update a checklist'
    param :checklist, Hash do
      param :name, :undef
    end
    param :name, :undef
    error code: 401
    error code: 422
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

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
    api :DELETE, '/v1/checklists/:id', 'Destroy a checklist'
    error code: 401
    error code: 422
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
