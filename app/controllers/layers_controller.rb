# API controller for Layers, used in Kanban
class LayersController < ActionController::API
  before_action :set_story, only: [:move]

  # GET /kanban/:id/move/:layer
  # Move specific artifact to layer
  def move
    if @story.update(layer: params[:layer])
      render status: 200, json: { message: 'Story moved!' }.to_json
    else
      # TODO: show @story errors
      render status: 500, json: { error: 'Something was wrong.' }.to_json
    end
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end
end
