class ArtifactsController < ApplicationController
  include ArtifactsHelper

  before_action :authorize, only: [:new, :new_type, :create]
  before_action :set_artifact, only: [:edit, :update]


  # Page with all artifacts type that could be created
  # GET /artifacts/new
  def new
    @artifacts = Array.new

    # In production eager_load is active, but development no
    Rails.application.eager_load!

    ApplicationRecord.descendants.each do |artifact|
      if artifact.is_a? Artifact
        @artifacts.push artifact
      end
    end
  end

  # Loads view to create selected artifact
  # GET /projects/:id/artifacts/new/:type
  def new_type
    # The name of resource, artifact name
    type = params[:type]
    # Used to select sources
    @all_artifacts = Artifact.where(project_id: params[:id], version: "snapshot")

    # Creates artifact dynamically through artifact type
    begin
      @artifact = get_request_instance type
      @artifact.project_id = params[:id]

      render get_view(type, 'new'), object: @artifact
    rescue ArtifactsHelper::InvalidKlassNameError => error
      redirect_to_error_page error.message
    end

  end

  # GET /:type/edit/:id
  def edit
    artifact = get_klass(params[:type]).find(params[:id])

    # The user should not access edit page of previous versions
    # TODO maybe we could render to a new page, with more explains
    unless artifact.version.eql? "snapshot"
      redirect_to controller: 'projects', action: 'show', id: artifact.project_id
      puts "Sorry but this is a old version and can not be edited..."
    else
      # The name of resource, artifact name
      @type = params[:type]

      render get_view(@type, 'edit')
    end
  end

  # Update artifact creating a new version
  # PUT /:type/:id
  def update
    @type = @artifact.actable_type.downcase

    artifact_param = artifact_params.except(:type)

    origin_artifact = get_klass(artifact_params[:type]).find(params[:id])
    artifact_param[:origin_artifact] = origin_artifact.artifact

    artifact_param[:author_id] = origin_artifact.author_id
    artifact_param[:project_id] = origin_artifact.project_id

    if origin_artifact.version.eql? "snapshot"
      origin_artifact.version = "snapshot_#{params[:id]}"
    end

    @artifact = get_request_instance(@type, artifact_param)

    if @artifact.save && origin_artifact.save
      flash[:notice] = "Artifact updated succeed"
    else
      flash[:error] = @artifact.errors || origin_artifact.errors
    end

    redirect_to action: "edit", id: @artifact.id || origin_artifact.id, type: @type
  end

  # Save a instance of specific artifact
  # POST /artifacts/new
  def create
    begin
      @artifact = get_request_instance(artifact_params[:type], artifact_params)
      @artifact.author_id = current_user.id

      if @artifact.save
        redirect_to @artifact.project
      else
        @all_artifacts = Artifact.where(project_id: artifact_params[:project_id], version: "snapshot")

        render get_view(@artifact.actable_type, 'new'), status: 400
      end
    rescue ArtifactsHelper::InvalidKlassNameError => error
      redirect_to_error_page error.message
    end
  end

  # Shows artifact selected
  # GET /artifacts/:id
  def show
    @artifact = Artifact.find(params[:id]).specific

    render get_view(@artifact.actable_type, 'show')
  end

  private

  def artifact_params
    # permit all params
    params.require(:artifact).permit!
  end

  def set_artifact
    type = params[:type] || artifact_params[:type]

    # gets the artifact's class and search by activerecord method
    @artifact = get_klass(type).find(params[:id])
  end

  # TODO Throws error if page null
  def get_view(klass, page)
    # The default of the rails views folders is lowercase and plural
    klass.downcase.pluralize + '/' + page
  end
end
