require 'rails_helper'

RSpec.describe ArtifactsHelper, type: :helper do
  describe "request instance of Note" do
    it "when klass_name is valid and without params" do
      expect(get_request_instance("Note")).to be_a_kind_of(Note)
    end

    it "when klass_name is valid with valid param" do
      params = { content: "Hello World" }
      expect(get_request_instance("Note", params)).to be_a_kind_of(Note)
    end

    it "when klass_name is invalid and without params" do
      expect {
        get_request_instance("Nevermind")
      }.to raise_error(ArtifactsHelper::InvalidKlassNameError)
    end
  end
end
