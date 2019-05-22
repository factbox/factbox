# This module have some critical code used in artifact controller
module ArtifactsHelper
  # This error is throwed when the follow method can not instantiate a class
  # because it dont exist or probably is in a bad format
  class InvalidKlassNameError < StandardError
    def initialize(msg)
      super(msg)
    end
  end

  # Returns an instance of string class name passed.
  # See the follow links to understand this parser
  #   - https://apidock.com/rails/ActiveSupport/Inflector/classify
  #   - https://apidock.com/rails/ActiveSupport/Inflector/safe_constantize
  def instantiate_artifact(klass_name, params = nil)
    klass = get_klass(klass_name.strip)

    if params
      klass.new(params.except(:type))
    else
      klass.new
    end
  rescue NoMethodError => _
    raise InvalidKlassNameError,
          "Please verify if exists artifact named '#{klass_name}'"
  end

  # Used in instantiate artifact
  # @deprecated to find, instead use Artifact.find().specific
  def get_klass(klass_name)
    klass_name.classify.safe_constantize
  end
end
