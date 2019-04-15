# Simple functional artifact.
class Image < ApplicationRecord
  acts_as :artifact
  has_one_attached :file

  validates :file, presence: true

  def self.glyph_icon
    'glyphicon-file'
  end

  # See Artifact#node_options
  def node_options
    {
      color: {
        border: '#34495e',
        background: last_version ? '#2ecc71' : '#7f8c8d'
      }
    }
  end
end
