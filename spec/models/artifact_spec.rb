require 'rails_helper'

RSpec.describe Artifact, type: :model do
  describe 'initialized in before(:all)' do
    let(:project) { FactoryBot.create(:project) }
    let(:note) { FactoryBot.create(:note, project_id: project.id) }

    it 'has a valid factory' do
      expect(note).to be_valid
    end

    it 'has a valid edit link' do
      expect(note.edit_link).to eq("/#{project.uri_name}/note/edit/#{note.uri_name}")
    end
  end
end
