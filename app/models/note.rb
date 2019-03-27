# Simple functional artifact.
class Note < ApplicationRecord
  acts_as :artifact

  validates :content, presence: false

  # See Artifact#glyphicon
  def self.glyph_icon
    'glyphicon-comment'
  end

  # See Artifact#node_options
  def node_options
    {
      color: {
        border: '#34495e',
        background: last_version ? '#f1c40f' : '#7f8c8d'
      }
    }
  end
end
