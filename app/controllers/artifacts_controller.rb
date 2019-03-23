# Controller for manage all existing artifacts types, including plugins.
class ArtifactsController < ApplicationController
  include ArtifactsHelper

  before_action :authorize, only: [:new, :new_type, :create]
  before_action :set_artifact, only: [:edit, :update]

  # List all specific artifact types
  # GET /:project_id/:resource
  def index
    # The architecture is expecting this name in plural
    pluralized_artifact = params[:resource]

    artifact_klass = get_klass(pluralized_artifact.singularize)
    @artifacts = artifact_klass.where(project_id: params[:project_id])

    @project = Project.find(params[:project_id])

    render "#{pluralized_artifact}/index"
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
    @available_artifacts = Artifact.where(
      project_id: params[:id], version: 'snapshot'
    )

    # Creates artifact dynamically through artifact type
    @artifact = instantiate_artifact(params[:type])
    @artifact.project_id = params[:id]

    render get_view(params[:type], 'new'), object: @artifact
  rescue ArtifactsHelper::InvalidKlassNameError => error
    redirect_to_error_page error.message
  end

  # Find artifact and render your edit page
  # GET /:type/edit/:id
  def edit
    # TODO: Treat an error if this where return two ids
    # Should find first and unique artifact to get your 'specific' reference
    actable_type = params[:type].capitalize
    @artifact = Artifact.where(actable_type: actable_type, id: params[:id])
                        .first.specific

    # The user should not access edit page of previous versions
    # TODO: maybe we could render to a new page, with more explains
    if @artifact.version.eql? 'snapshot'
      # The name of resource, artifact name
      @type = @artifact.actable_type.downcase

      @available_artifacts = Artifact.where(project_id: @artifact.project_id)

      render get_view(@type, 'edit')
    else
      project_id = @artifact.project_id
      redirect_to controller: 'projects', action: 'show', id: project_id
    end
  end

  # Update artifact creating a new version
  # PUT /:type/:id
  def update
    @type = artifact_params[:type]

    origin_artifact = get_klass(artifact_params[:type]).find(params[:id])
    origin_artifact.update_version(params[:id])

    artifact_args = generate_artifact_args(origin_artifact)

    @artifact = instantiate_artifact(@type, artifact_args)

    if @artifact.save && origin_artifact.save
      flash[:notice] = 'Artifact updated succeed'
    else
      flash[:error] = @artifact.errors || origin_artifact.errors
    end

    specific_id = @artifact.id || origin_artifact.id

    redirect_to action: 'edit', id: specific_id, type: @type
  end

  # Save a instance of specific artifact
  # POST /artifacts/new
  def create
    @artifact = instantiate_artifact(artifact_params[:type], artifact_params)
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
    @artifact = find_by_project_and_title

    render get_view(@artifact.actable_type, 'show')
  end

  # Show previous versions of one Artifact
  # GET :project_id/versions/:name
  def show_versions
    @artifact = find_by_project_and_title

    @versions = [@artifact]

    version = @artifact.origin_artifact
    until version.nil?
      @versions.push version
      version = version.origin_artifact
    end
  end

  private

  def artifact_params
    # permit all params
    params.require(:artifact).permit!
  end

  # Used in update to copy properties of source
  def generate_artifact_args(origin_artifact)
    artifact_params.merge(
      origin_artifact: origin_artifact.artifact,
      author_id: origin_artifact.author_id,
      project_id: origin_artifact.project_id
    )
  end

  def find_by_project_and_title
    Artifact.where(project_id: params[:project_id], title: params[:title]).first
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
