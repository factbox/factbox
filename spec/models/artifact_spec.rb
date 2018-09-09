require 'rails_helper'
require 'database_cleaner'

RSpec.describe Artifact, type: :model do

  before(:all) do
    @note = FactoryBot.create(:note)
  end

  it "has a valid factory" do
    expect(@note).to be_valid
  end

  it "has a valid edit link" do
    expect(@note.edit_link).to eq("/artifacts/edit/1/note")
  end

end
