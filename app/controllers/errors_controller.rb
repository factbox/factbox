# Custom errors for system
class ErrorsController < ApplicationController
  # GET /404
  def not_found; end

  # GET /401
  def not_authorized; end
end
