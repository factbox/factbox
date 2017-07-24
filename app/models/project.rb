class Project < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: true, length:{in: 2..20}
  validates :description, presence: true, length:{in: 2..50}

end
