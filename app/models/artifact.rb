# This model is the core of artifacts system, and keeps only some mainly
# attributes like author_id, project_id, title, description, created_at
# and updated_at.
# To use it, you need use the gem active_record-acts_as, like does Note model.
# See file app/models/note.rb
class Artifact < ApplicationRecord
  actable
  # previous version of this artifact
  has_one    :origin_artifact, class_name: 'Artifact', foreign_key: 'artifact_id'
  belongs_to :project
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :title, presence: true, length:{in: 2..20}
  validates :description, presence: true, length:{in: 2..100}
  validates :version, presence: true

  def edit_link
    "/artifacts/edit/#{self.id}/#{self.actable_type.downcase}"
  end
end
