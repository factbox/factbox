# Simple functional artifact.
class Image < ApplicationRecord
  acts_as :artifact
  has_one_attached :file

  validates :file, presence: true

  def self.glyph_icon
    "glyphicon-file"
  end

  # See Artifact#node_options
  def node_options
    superklass = self.acting_as
    {
      id: superklass.id,
      label: "#{superklass.actable_type}_#{superklass.id}",
      color: {
        border: "#95a5a6",
        background: "#2ecc71",
        hover: {
          background: "#2ecc71"
        },
      },
    }
  end
end
