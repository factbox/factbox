# This model is the core of artifacts system, and keeps only some mainly
# attributes like author_id, project_id, title, description, created_at
# and updated_at.
# To use it, you need use the gem active_record-acts_as, like does Note model.
# See file app/models/note.rb
class Artifact < ApplicationRecord
  include Versionable

  actable
  # previous version of this artifact
  belongs_to :origin_artifact, class_name: 'Artifact', foreign_key: 'origin_id', optional: true

  belongs_to :project, optional: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: true

  # reference of artifacts sources
  has_many   :children, class_name: 'Artifact', foreign_key: 'source_id'
  belongs_to :source, class_name: 'Artifact', optional: true

  validates :title, presence: true, length: { in: 2..20 }

  # method in Versionable concern
  before_validation :generate_version

  def time_creation
    created_at.strftime('%B %d %Y %H:%M')
  end

  def edit_link
    "/#{actable_type.downcase}/edit/#{id}"
  end

  def show_link
    "/#{project_id}/artifact/#{title}"
  end

  # Get glyphicon that should be used by each artifact type
  def glyph_icon
    # to be override for each artifact type
    subclass.try(:glyph_icon) ? subclass.glyph_icon : 'glyphicon-file'
  end

  # That options are used in /traceability/project_title.
  # In each artifact kind we can add properties
  # to style this representation in traceability graph.
  # All properties are available in:
  # http://visjs.org/docs/network/nodes.html
  def node_options
    options = {
      id: id,
      label: title,
      shape: 'dot'
    }

    options.merge(actable.node_options) unless actable.node_options.nil?
  end

  private

  # Get real klass of artifact
  def subclass
    actable_type.classify.safe_constantize
  end
end
