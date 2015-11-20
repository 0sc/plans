class ApplicationController < ActionController::API
  # include ::ActionController::Serialization

  def current_user
    User.first
  end

  def set_current_user_checklists
    @my_checklists = current_user.checklists
  end

  def get_checklist(col = :id, data = params[:id] )
    @checklist = @my_checklists.find_by(col => data)
    render json: "", status: :unprocessable_entity unless @checklist
  end
end
