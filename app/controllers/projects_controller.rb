class ProjectsController < ApplicationController

  before_action :authorize, only: [:index, :new, :create]
  before_action :set_project, only: [:show, :edit, :update]

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

  # Page for edit projects
  # GET /projects/:id/edit
  def edit
  end

  # Action to update projects
  # PUT /projects/:id
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Projeto atualizado com sucesso'
    else
      render :edit
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
