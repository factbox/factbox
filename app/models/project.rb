# Model that represents the projects
class Project < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: true
  has_many :artifacts

  validates_uniqueness_of :name
  validates :name, presence: true, length: { in: 2..20 }
  validates :description, presence: true, length: { in: 2..100 }

  def last_versions
    Artifact.where(project_id: id, last_version: true)
  end
end
