class Artifact < ApplicationRecord
  belongs_to :project

  validates :title, presence: true, length:{in: 2..20}
  validates :description, presence: true, length:{in: 2..100}
end
