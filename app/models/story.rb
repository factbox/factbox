# Simple functional artifact.
class Story < ApplicationRecord
  acts_as   :artifact
  validates :story, presence: false
  has_many  :criterias, dependent: :destroy
  accepts_nested_attributes_for :criterias, allow_destroy: true

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
