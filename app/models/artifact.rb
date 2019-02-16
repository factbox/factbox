# This model is the core of artifacts system, and keeps only some mainly
# attributes like author_id, project_id, title, description, created_at
# and updated_at.
# To use it, you need use the gem active_record-acts_as, like does Note model.
# See file app/models/note.rb
class Artifact < ApplicationRecord
  actable
  # previous version of this artifact
  belongs_to :origin_artifact, class_name: 'Artifact', foreign_key: 'origin_id', optional: true

  belongs_to :project, optional: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: true

  # reference of artifacts sources
  has_many   :children, class_name: 'Artifact', foreign_key: 'source_id'
  belongs_to :source, class_name: 'Artifact', optional: true

  validates :title, presence: true, length:{in: 2..20}
  validates :version, presence: true

  def edit_link
    "/#{self.actable_type.downcase}/edit/#{self.actable_id}"
  end

  def show_link
    "/#{self.project_id}/artifact/#{self.title}"
  end

  # Get glyphicon that should be used by each artifact type
  def glyph_icon
    # to be override for each artifact type
    subclass.glyph_icon || "glyphicon-file"
  end

  private

    # Get real klass of artifact
    def subclass
      klass = self.actable_type.classify.safe_constantize
      return klass
    end
end
