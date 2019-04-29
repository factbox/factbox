require 'kramdown'

# Controller for manage all existing artifacts types, including plugins.
class ArtifactsController < ApplicationController
  include ArtifactsHelper

  before_action :authorize, except: [:show, :show_version, :show_versions]
  before_action :check_project_privacity, only: [:show, :show_version, :show_versions]
  before_action :set_artifact, only: [:edit]
  before_action :find_by_project_and_title, only: [:show_versions, :show]

  # List all specific artifact types
  # GET /:project_id/:resource
  def index
    # The architecture is expecting this name in plural
    pluralized_artifact = params[:resource]

    artifact_klass = get_klass(pluralized_artifact.singularize)
    @project = Project.find_by_name(params[:project_name])

    @artifacts = artifact_klass.where(project_id: @project.id)

    render "#{pluralized_artifact}/index"
  end

  # Page with all artifacts type that could be created
  # GET /projects/:name/artifacts/new
  def new
    @artifacts = []

    # In production eager_load is active, but development no
    Rails.application.eager_load!

    ApplicationRecord.descendants.each do |artifact|
      @artifacts.push artifact if artifact.is_a? Artifact
    end
  end

  # Loads view to create selected artifact
  # GET /projects/:name/artifacts/new/:type
  def new_type
    project = Project.find_by_name(CGI.unescape(params[:name]))

    # Used to select sources
    @available_artifacts = Artifact.where(
      project_id: project.id, last_version: true
    )

    # Creates artifact dynamically through artifact type
    @artifact = instantiate_artifact(params[:type])
    @artifact.project = project

    render get_view(params[:type], 'new'), object: @artifact
  rescue ArtifactsHelper::InvalidKlassNameError => error
    redirect_to_error_page error.message
  end

  # Find artifact and render your edit page
  # GET /:type/edit/:title
  def edit
    # The user should not access edit page of previous versions
    if @artifact && @artifact.specific.last_version
      load_available_artifacts

      # Views are prepared to receive specific
      @artifact = @artifact.specific

      # The name of resource, artifact name
      @type = @artifact.actable_type.downcase

      render get_view(@type, 'edit')
    else
      flash[:warning] = 'Sorry, but previous artifacts can not be edited...'
      redirect_to project_show_url(@project, name: @project.name)
    end
  end

  # Update artifact creating a new version
  # PUT /type/:id
  def update
    @type = artifact_params[:type].downcase

    origin_artifact = get_klass(artifact_params[:type]).find(params[:id])
    origin_artifact.discontinue

    generate_new_version(origin_artifact)

    if @artifact.save && origin_artifact.save
      flash[:success] = 'Artifact updated succeed'
      redirect_to action: :edit,
                  project_name: @artifact.project.uri_name,
                  type: @type, title: @artifact.uri_name
    else
      # reassign @artifact to validate form
      build_artifact_to_form(origin_artifact)
      load_available_artifacts
      render get_view(@type, 'edit')
    end
  end

  # Save a instance of specific artifact
  # POST /artifacts/new
  def create
    @artifact = instantiate_artifact(artifact_params[:type], artifact_params)
    @artifact.author_id = current_user.id
    @artifact.generate_version
    @artifact.is_new = true

    if @artifact.save
      flash[:success] = 'Artifact created with success.'
      redirect_to project_show_url(@artifact.project.uri_name)
    else
      load_available_artifacts

      render get_view(@artifact.actable_type, 'new'), status: 400
    end
  rescue ArtifactsHelper::InvalidKlassNameError => error
    redirect_to_error_page error.message
  end

  # Artifacts are not trully deleted
  # DELETE /artifact/:id
  def destroy
    @artifact = Artifact.find(params[:id])

    @artifact.last_version = false

    if @artifact.save
      flash[:success] = 'The artifact was deleted successfully'
    else
      flash[:error] = @artifact.errors
    end

    redirect_to project_show_url(@artifact.project.uri_name)
  end

  # Shows artifact selected
  # GET :project_name/artifacts/:name
  def show
    render get_view(@artifact.actable_type, 'show')
  end

  # Show previous versions of one Artifact
  # GET :project_name/versions/:name
  def show_versions
    @versions = [@artifact]

    version = @artifact.origin_artifact
    until version.nil?
      @versions.push version
      version = version.origin_artifact
    end
  end

  # Show specific version
  # GET /:project_name/version/:hash
  def show_version
    project = Project.find_by_name(CGI.unescape(params[:project_name]))
    options = { project_id: project.id, version: [params[:hash]] }

    @artifact = Artifact.where(options).first

    render get_view(@artifact.actable_type, 'show')
  end

  private

  def artifact_params
    # permit all params
    params.require(:artifact).permit!
  end

  # Used in update, when request fails.
  # Basically we need build @artifact mounted in edit action
  # because this reference is reassign to origin_artifact
  def build_artifact_to_form(origin_artifact)
    form_attributes = params[:artifact].to_h
    # type is useless for artifact.specific
    form_attributes.delete :type

    # save errors
    errors = @artifact.errors

    # reassign to persisted object
    @artifact = origin_artifact

    # Overwrite with form data
    @artifact.assign_attributes form_attributes
    # Add each validation throwed
    errors.each do |k, e|
      @artifact.errors.add k, e
    end
  end

  # Load all artifacts to use as source
  def load_available_artifacts
    # artifact should not point to self as source
    @available_artifacts = find_latest_versions.reject { |v| v == @artifact }
  end

  # Used in update to copy properties of source
  def generate_artifact_args(origin_artifact)
    artifact_params.merge(
      origin_artifact: origin_artifact.acting_as,
      author_id: current_user.id,
      project_id: origin_artifact.project_id
    )
  end

  # Check versionable.rb to understand discontinue and generate_version
  def generate_new_version(origin_artifact)
    artifact_args = generate_artifact_args(origin_artifact)

    @artifact = instantiate_artifact(artifact_params[:type], artifact_args)
    @artifact.generate_version
  end

  def find_project_by_name
    Project.find_by_name(CGI.unescape(params[:project_name]))
  end

  def find_by_project_and_title
    project = find_project_by_name

    @artifact = Artifact.where(
      project_id: project.id,
      title: CGI.unescape(params[:title]),
      last_version: true
    ).first
  end

  # TODO: Throws error if page null
  def get_view(klass, page)
    # The default of the rails views folders is lowercase and plural
    "#{klass.downcase.pluralize}/#{page}"
  end

  def find_latest_versions
    Artifact.where(project_id: @artifact.project_id, last_version: true)
  end

  # TODO: Treat an error if this where return two ids
  # Should find first and unique artifact to get your 'specific' reference
  def set_artifact
    actable_type = params[:type].capitalize
    @project = find_project_by_name
    @artifact = Artifact.where(project_id: @project.id,
                               actable_type: actable_type,
                               last_version: true,
                               title: CGI.unescape(params[:title])).first
  end
end
