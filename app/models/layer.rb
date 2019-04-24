# Entity used by Kanban plugin
class Layer < ApplicationRecord
  belongs_to :project

  validates :name, presence: true, length: { in: 2..20 }
  validates_uniqueness_of :name, scope: :project_id, on: :create,
                                 message: 'This layer already exist to this'
end
