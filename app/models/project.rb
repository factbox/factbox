# Model that represents the projects
class Project < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: true
  has_many :artifacts
  has_one_attached :logo
  has_and_belongs_to_many :users

  validates_uniqueness_of :name
  validates :name, presence: true, length: { in: 2..20 }
  validates :description, presence: true, length: { in: 2..100 }

  # method to encode name of project
  def uri_name
    CGI.escape(self[:name])
  end

  def default_logo
    options = 'theme=seascape&numcolors=4&size=200&fmt=svg'
    "http://tinygraphs.com/squares/#{self[:name]}?#{options}"
  end

  def last_versions
    Artifact.where(project_id: id, last_version: true)
  end
end
