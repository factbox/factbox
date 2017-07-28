class ProjectsController < ApplicationController

  # Used like home page of logged users
  # GET /projects
  def index
    # Check User#projects to see this overrided method
    @user_projects = current_user.projects
  end

  # TODO change :id to name with properly encoding
  # Shows specific project
  # GET /projects/:id
  def show
    @project = Project.find(params[:id])
  end

  # Form page to new projects
  # GET /projects/new
  def new
    @project = Project.new
  end

  # Create new projects
  # POST /projects
  def create
    @project = Project.new(project_params)

    @project.author_id = current_user.id

    if @project.save
      redirect_to projects_path, notice: "Project created successful"
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
