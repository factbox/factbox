# Contain some helper methods to be used in all controllers
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  private

  def current_user
    db_user = User.find(session[:user_id])
    @current_user ||= db_user if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    @current_user = nil
  end

  # used in check_project_privacity
  def user_belongs_to_project
    current_user && current_project && current_project.users.exists?(current_user.id)
  end

  def check_project_permission
    redirect_to not_authorized_path unless user_belongs_to_project
  end

  def check_project_privacity
    is_allowed = current_project.is_public || user_belongs_to_project
    redirect_to not_found_path unless is_allowed
  end

  def logged_in?
    session[:user_id]
  end

  def authorize
    redirect_to root_path unless logged_in?
  end

  def redirect_to_error_page(msg)
    @message = msg
    render 'layouts/error', status: 500
  end

  def current_project
    # TODO standize all to project_name
    project_name = params[:project_name] || params[:name]
    Project.find_by_name(CGI.unescape(project_name))
  end

  helper_method :current_user, :logged_in?, :authorize, :check_project_privacity
end
