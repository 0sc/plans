class Api::V1::ChecklistsController < ApplicationController
  before_action :set_current_user_checklists, except: :create
  before_action :get_checklist, except: [:index, :create]

  def index
    checklists = @my_checklists
    q = params[:q]
    checklists = q ? checklists.where("name Like ?", "%#{q}%") : checklists.all
    render json: checklists#, serializer: ChecklistSerializer
  end

  def create
    checklist = Checklist.new(name: params[:name])
    checklist.user = current_user
    if checklist.save
      render json: checklist, status: :success
    else
      render json: checklist.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @checklist
  end

  def update
    if @checklist.update(name: params[:name])
      render json: @checklist
    else
      render json: @checklist.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @checklist.destroy
    render json: ""
  end

  private

end
