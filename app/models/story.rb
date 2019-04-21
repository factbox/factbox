# Simple functional artifact.
class Story < ApplicationRecord
  acts_as :artifact
  enum layer: [:todo, :doing, :done]

  validates :story, presence: false

  def self.plugin_name
    'Kanban'
  end

  # See Artifact#node_options
  def node_options
    {
      color: {
        border: '##34495e',
        background: last_version ? '#16a085' : '#7f8c8d'
      }
    }
  end
end
