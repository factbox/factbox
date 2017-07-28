module ArtifactsHelper

  def types
    @artifact_types = Hash.new
    @artifact_types[:note] = Note
    return @artifact_types
  end

  def build(artifact_type)
    return types[artifact_type].new
  end
end
