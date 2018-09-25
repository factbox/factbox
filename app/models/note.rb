# Simple functional artifact.
class Note < ApplicationRecord
  acts_as :artifact

  validates :content, presence: false

  def self.glyph_icon
    "glyphicon-comment"
  end
end
