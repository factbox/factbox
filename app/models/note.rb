# Simple functional artifact.
class Note < ApplicationRecord
  acts_as :artifact

  validates :content, presence: false
end
