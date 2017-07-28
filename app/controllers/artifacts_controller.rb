class ArtifactsController < ApplicationController
  include ArtifactsHelper

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
  # GET /artifacts/new/:type
  def new_type
    type = params['type']

    # Creates artifact dynamically through artifact type
    @artifact = type.classify.safe_constantize.new
    # The default of the rails views folders is lowercase and plural
    view = type.downcase + 's/new'

    render view, object: @artifact
  end

end
