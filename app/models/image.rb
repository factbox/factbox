# Simple functional artifact.
class Image < ApplicationRecord
  acts_as :artifact
  has_one_attached :file

  validates :file, presence: true

  def self.glyph_icon
    "glyphicon-file"
  end
end
