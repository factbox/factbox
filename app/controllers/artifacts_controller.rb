# Controller for manage all existing artifacts types, including plugins.
class ArtifactsController < ApplicationController
  include ArtifactsHelper

  before_action :authorize, only: [:new, :new_type, :create]
  before_action :set_artifact, only: [:edit, :update]

  # List all specific artifact types
  # GET /{artifact}
  def index
    Rails.application.routes.router.recognize(request) do |route, _|
      # The architecture is expecting this name in plural
      pluralized_artifact = route.name

      artifact_klass = get_klass(pluralized_artifact.singularize)
      @artifacts = artifact_klass.all

      render "#{pluralized_artifact}/index"
    end
  end

  # Page with all artifacts type that could be created
  # GET /projects/:id/artifacts/new
  def new
    @artifacts = []

    # In production eager_load is active, but development no
    Rails.application.eager_load!

    ApplicationRecord.descendants.each do |artifact|
      @artifacts.push artifact if artifact.is_a? Artifact
    end
  end

  # Loads view to create selected artifact
  # GET /projects/:id/artifacts/new/:type
  def new_type
    # Used to select sources
    @all_artifacts = Artifact.where project_id: params[:id], version: 'snapshot'

    # Creates artifact dynamically through artifact type
    begin
      @artifact = get_request_instance params[:type]
      @artifact.project_id = params[:id]

      render get_view(params[:type], 'new'), object: @artifact
    rescue ArtifactsHelper::InvalidKlassNameError => error
      redirect_to_error_page error.message
    end
  end

  # Find artifact and render your edit page
  # GET /:type/edit/:id
  def edit
    # TODO: Treat an error if this where return two ids
    # Should find first and unique artifact to get your 'specific' reference
    @artifact = Artifact.where(
      actable_type: params[:type].capitalize,
      id: params[:id]
    ).first.specific

    # The user should not access edit page of previous versions
    # TODO maybe we could render to a new page, with more explains
    if @artifact.version.eql? 'snapshot'
      # The name of resource, artifact name
      @type = @artifact.actable_type.downcase

      @all_artifacts = Artifact.where(project_id: @artifact.project_id)

      render get_view(@type, 'edit')
    else
      redirect_to(
        controller: 'projects',
        action: 'show',
        id: @artifact.project_id
      )
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

    if origin_artifact.version.eql? 'snapshot'
      origin_artifact.version = "snapshot_#{params[:id]}"
    end

    @artifact = get_request_instance(@type, artifact_param)

    if @artifact.save && origin_artifact.save
      flash[:notice] = 'Artifact updated succeed'
    else
      flash[:error] = @artifact.errors || origin_artifact.errors
    end

    redirect_to action: 'edit', id: @artifact.id || origin_artifact.id, type: @type
  end

  # Save a instance of specific artifact
  # POST /artifacts/new
  def create
    @artifact = get_request_instance(artifact_params[:type], artifact_params)
    @artifact.author_id = current_user.id

    if @artifact.save
      redirect_to @artifact.project
    else
      @all_artifacts = Artifact.where(
        project_id: artifact_params[:project_id],
        version: 'snapshot'
      )

      @artifact.errors.full_messages.each do |message|
        puts message
      end

      render get_view(@artifact.actable_type, 'new'), status: 400
    end
  rescue ArtifactsHelper::InvalidKlassNameError => error
    redirect_to_error_page error.message
  end

  # Artifacts are not trully deleted
  # DELETE /artifact/:id
  def destroy
    @artifact = Artifact.find(params[:id])

    @artifact.version = 'deleted'

    if @artifact.save
      flash[:notice] = 'The artifact was deleted successfully'
    else
      flash[:error] = @artifact.errors
    end

    redirect_to @artifact.project
  end

  # Shows artifact selected
  # GET :project_id/artifacts/:name
  def show
    @artifact = Artifact.where(
      project_id: params[:project_id],
      title: params[:title]
    ).first

    render get_view(@artifact.actable_type, 'show')
  end

  private

  def artifact_params
    # permit all params
    params.require(:artifact).permit!
  end

  def set_artifact
    @artifact = Artifact.find(params[:id]).specific
  end

  # TODO: Throws error if page null
  def get_view(klass, page)
    # The default of the rails views folders is lowercase and plural
    "#{klass.downcase.pluralize}/#{page}"
  end
end
