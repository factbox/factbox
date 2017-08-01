class ArtifactsController < ApplicationController
  include ArtifactsHelper

  before_action :authorize, only: [:new, :new_type, :create]

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
    type = params[:type]

    # Creates artifact dynamically through artifact type
    begin
      @artifact = get_request_instance type
      @artifact.project_id = params[:id]

      render get_view(type, 'new'), object: @artifact
    rescue ArtifactsHelper::InvalidKlassNameError => error
      redirect_to_error_page error.message
    end

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
        render get_view(@artifact.actable_type, 'new')
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

  # TODO Throws error if page null
  def get_view(klass, page)
    # The default of the rails views folders is lowercase and plural
    klass.downcase + 's/' + page
  end
end
