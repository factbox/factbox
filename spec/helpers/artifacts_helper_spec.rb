require 'rails_helper'

RSpec.describe ArtifactsHelper, type: :helper do
  describe "request instance of Note" do
    it "when klass_name is valid and without params" do
      expect(instantiate_artifact("Note")).to be_a_kind_of(Note)
    end

    it "when klass_name is valid with valid param" do
      params = { content: "Hello World" }
      expect(instantiate_artifact("Note", params)).to be_a_kind_of(Note)
    end

    it "when klass_name is invalid and without params" do
      expect {
        instantiate_artifact("Nevermind")
      }.to raise_error(ArtifactsHelper::InvalidKlassNameError)
    end
  end
end
