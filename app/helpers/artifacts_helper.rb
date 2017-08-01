module ArtifactsHelper

  class InvalidKlassNameError < StandardError
    def initialize(msg)
      super(msg)
    end
  end

  # Returns an instance of string class name passed.
  # See the follow links to understand this parser
  #   - https://apidock.com/rails/ActiveSupport/Inflector/classify
  #   - https://apidock.com/rails/ActiveSupport/Inflector/safe_constantize
  def get_request_instance(klass_name, params=nil)
    klass = nil

    begin
      klass = klass_name.classify.safe_constantize
      if params
        klass.new(params.except(:type))
      else
        klass.new
      end
    rescue NoMethodError => e
      raise InvalidKlassNameError.new("Please verify if exists artifact named #{klass_name}")
    end
  end

end
