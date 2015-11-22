module V1
  class ChecklistsController < BaseController
    before_action :set_current_user_checklists, except: :create
    before_action :get_checklist, except: [:index, :create]

    def index
      checklists = @my_checklists
      q = params[:q]
      checklists = q ? checklists.where("name Like ?", "%#{q}%") : checklists.all

      paginate = PaginationManager.new(params, checklists)
      render json: paginate.query, meta: paginate.set_meta_tag, status: 200
    end

    def create
      checklist = Checklist.new(checklist_params)
      checklist.user = current_user
      if checklist.save
        render json: checklist, status: 201#, location: checklist
      else
        render json: checklist.errors.full_messages, status: 422
      end
    end

    def show
      render json: @checklist, status: 200
    end

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
