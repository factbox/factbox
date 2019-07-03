require 'digest'

# This module controls version features of artifact
module Versionable
  extend ActiveSupport::Concern

  # Should include this follow properties inside the Artifact
  included do
    validates :version, presence: true
    has_many :votes
  end

  # Method used when artifact is updated
  # Basically, it update the version attribute
  def generate_version
    self.version = Digest::SHA1.hexdigest to_json
  end

  # Method used to discontinue one artifact.
  # When an artifact is created, the old keeps as a separated register.
  # To identifier which is the newest, this property should be true.
  def discontinue
    self.last_version = false
  end
end
