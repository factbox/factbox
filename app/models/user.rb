# Model used to represents User
class User < ApplicationRecord
  has_and_belongs_to_many :projects
  has_many :artifacts
  has_one_attached :avatar
  has_secure_password

  validates :name, presence: true, length: { in: 2..20 }
  validates :lastName, presence: true, length: { in: 2..20 }
  validates :email, confirmation: true, presence: true, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :password, presence: true, on: :create, length: { minimum: 6 }, confirmation: true

  def default_avatar
    avatar_opt = 'theme=frogideas&numcolors=4&size=220&fmt=svg'
    "http://tinygraphs.com/labs/isogrids/hexa16/#{self[:login]}?#{avatar_opt}"
  end
end
