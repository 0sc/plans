class Api::V1::ItemsController < ApplicationController
  before_action :set_current_user_checklists
  before_action { get_checklist(:id, params[:checklist_id]) }
  before_action :get_checklist_item, only: [:show, :destroy, :update]

  def index
    if params[:q]
      q = params[:a]
      if q == "done"
        render json: @checklist.completed
      elsif q == "pending"
        render json: @checklist.pending
      end
    else
      render json: "", status: :unprocessable_entity
    end
    render json: @checklist.items
  end

  def create
    item = @checklist.items.new(name: params[:name])
    item.done = params[:done] if params[:done]
    if item.save
      render json: item
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @item
  end

  def destroy
    @item.destroy
    render json: ""
  end

  def update
    done = params[:done] ? params[:done] : @item.done
    name = params[:name] ? params[:name] : @item.name
    if @item.update(name: name, done: done)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  private

  def get_checklist_item
    @item = @checklist.items.find_by(id: params[:id])
    render json: "", status: :unprocessable_entity unless @item
  end
end
