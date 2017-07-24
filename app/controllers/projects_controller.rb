class ProjectsController < ApplicationController
  def index
    @user_projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    @project.author_id = current_user.id

    if @project.save
      redirect_to projects_path, notice: "Pay attention to the road"
    else
      render :new
    end
  end

  private
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
