require 'digest'

# This module controls version features of artifact
module Versionable
  extend ActiveSupport::Concern

  included do
    validates :version, presence: true
    has_many :votes
  end

  def generate_version
    self.version = Digest::SHA1.hexdigest to_json
  end

  def discontinue
    self.last_version = false
  end
end
