module V1
  class BaseController < ApplicationController
    before_action :authenticate_token

    def set_current_user_checklists
      @my_checklists = current_user.checklists
    end

    def get_checklist(col = :id, data = params[:id] )
      @checklist = @my_checklists.find_by(col => data)
      head 404, content_type: "application/json" unless @checklist
    end
  end
end
