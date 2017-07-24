class ProjectsController < ApplicationController
  def index
    @user_projects = current_user.projects
  end

  def new
    @project = Project.new
  end
end
