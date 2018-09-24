class Project < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :artifacts

  validates :name, presence: true, length:{in: 2..20}
  validates :description, presence: true, length:{in: 2..50}

  def snapshot_artifacts
    Artifact.where(project_id: self.id, version: "snapshot")
  end
end
