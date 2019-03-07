require 'rails_helper'

RSpec.describe Artifact, type: :model do

  describe "initialized in before(:all)" do
    before(:all) do
      @note = FactoryBot.build(:note)
      @note.save!
    end

    it "has a valid factory" do
      expect(@note).to be_valid
    end

    it "has a valid edit link" do
      expect(@note.edit_link).to eq("/note/edit/#{@note.id}")
    end
  end

end
