class User < ApplicationRecord
  has_and_belongs_to_many :projects
  has_secure_password

  validates :name, presence: true, length:{in: 2..20}
  validates :lastName, presence: true, length:{in: 2..20}
  validates :email, confirmation: true, presence: true, uniqueness: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :password, presence: { on: :create }, length:{ minimum: 6}, confirmation: true

  # Override method that gets all projects where user belongs
  # like membership or author
  def projects
    all_projects = Array.new
    all_projects += Project.where(author_id: id)
    all_projects += super

    return all_projects
  end

end
