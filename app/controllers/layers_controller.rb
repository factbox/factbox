# API controller for Layers, used in Kanban
class LayersController < ActionController::API
  before_action :set_story, only: [:move]
  before_action :check_project_permission

  # GET /kanban/move
  # Move specific artifact to layer
  def move
    layer = params[:layer] ? Layer.find(params[:layer]) : nil
    @story.update_attribute(:layer_id, layer ? layer.id : nil)

    if @story.save
      render status: 200, json: { message: 'Story moved!' }.to_json
    else
      # TODO: show @story errors
      render status: 500, json: { error: 'Something was wrong.' }.to_json
    end
  end

  def create
    @layer = Layer.new(layer_params)

    if @layer.save
      render status: 200, json: @layer.to_json
    else
      render status: 500, json: { error: @layer.errors }.to_json
    end
  end

  def destroy
    @layer = Layer.find(params[:id])

    if @layer.destroy
      # return stories of this layer, to update front
      stories = Story.where(layer_id: params[:id])

      stories.each do |s|
        s.layer_id = nil
        s.save
      end

      render status: 200, json: stories.to_json
    else
      render status: 500, json: { error: @layer.errors }.to_json
    end
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end

  def layer_params
    params.require(:layer).permit(:name, :project_id)
  end
end
