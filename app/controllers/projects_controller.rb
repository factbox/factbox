# Controller for project actions
class ProjectsController < ApplicationController
  before_action :authorize, only: [:index, :new, :create]
  before_action :set_project, only: [:show, :edit, :update]

  # Used like home page of logged users
  # GET /projects
  def index
    # Check User#projects to see this overrided method
    @user_projects = current_user.projects
  end

  # TODO: change :id to name with properly encoding
  # Shows specific project
  # GET /projects/:id
  def show
    @plugins = []
    # In production eager_load is active, but development no
    Rails.application.eager_load!

    ApplicationRecord.descendants.each do |artifact_klass|
      next unless artifact_klass.is_a? Artifact

      artifact_name = artifact_klass.name.downcase.pluralize
      next unless template_exists? "#{artifact_name}/index"

      # TODO: Treat when plugin have index file but the model
      # was not have plugin_name
      plugin_name = artifact_klass.plugin_name
      plugin_opt = { name: plugin_name, resource: artifact_name }

      @plugins.push plugin_opt
    end
  end

  # GET /traceability/:id
  def traceability
    artifacts = Artifact.where(project_id: params[:id])

    @nodes = []
    @edges = []

    artifacts.each do |a|
      # append edge of children to source
      unless a.children.empty?
        a.children.each do |children|
          edge = { from: children.id, to: a.id }
          @edges.push edge
        end
      end

      unless a.origin_artifact.nil?
        edge = { from: a.origin_artifact.id, to: a.id, dashes: true }
        @edges.push edge
      end

      # save current artifact as a node
      @nodes.push a.specific.node_options
    end

    render 'traceability'
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
      redirect_to projects_path, notice: 'Project created successful'
    else
      render :new
    end
  end

  # Page for edit projects
  # GET /projects/:id/edit
  def edit; end

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
