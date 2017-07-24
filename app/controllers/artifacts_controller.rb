class ArtifactsController < ApplicationController
  def new
    @artifact = Artifact.new
  end

  private
    def build(artifact_type)
      case artifact_type
      when :note
        return Note.new
      end
    end
end
