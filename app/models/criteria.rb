# Simple functional artifact.
class Criteria < ApplicationRecord
  belongs_to :story
  validates :content, presence: true, length: { in: 2..255 }
end
