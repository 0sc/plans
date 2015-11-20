module V1
  class ChecklistsController < ApplicationController
    before_action :set_current_user_checklists, except: :create
    before_action :get_checklist, except: [:index, :create]

    def index
      checklists = @my_checklists
      q = params[:q]
      checklists = q ? checklists.where("name Like ?", "%#{q}%") : checklists.all
      render json: checklists, status: 200
    end

    def create
      checklist = Checklist.new(checklist_params)
      checklist.user = current_user
      if checklist.save
        render json: checklist, status: 201#, location: checklist
      else
        render json: checklist.errors, status: 422
      end
    end

    def show
      render json: @checklist, status: 200
    end

    def update
      data = checklist_params
      if checklist_params.empty?
        render json: @checklist, status: 422
      else
        if @checklist.update(checklist_params)
          render json: @checklist, status: 200
        else
          render json: @checklist.errors, status: 422
        end
      end
    end

    def destroy
      @checklist.destroy
      head 204
    end

    private

    def checklist_params
      begin
        params.fetch(:checklist, {}).permit(:name)
      rescue
        head 400
      end
    end
  end
end
