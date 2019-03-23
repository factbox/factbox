# Simple functional artifact.
class Note < ApplicationRecord
  acts_as :artifact

  validates :content, presence: false

  # See Artifact#glyphicon
  def self.glyph_icon
    "glyphicon-comment"
  end

  # See Artifact#node_options
  def node_options
    superklass = acting_as
    {
      id: superklass.id,
      label: "#{superklass.actable_type}_#{superklass.id}",
      color: {
        border: '#95a5a6',
        background: '#3498db',
        hover: {
          background: '#2980b9'
        }
      }
    }
  end
end
