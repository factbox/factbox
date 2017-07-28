# This model is the core of artifacts system, and keeps only some mainly
# attributes like author_id, project_id, title, description, created_at
# and updated_at.
# To use it, you need use the gem active_record-acts_as, like does Note model.
# See file app/models/note.rb
class Artifact < ApplicationRecord
  actable
  belongs_to :project

  validates :title, presence: true, length:{in: 2..20}
  validates :description, presence: true, length:{in: 2..100}
end
