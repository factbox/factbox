require 'rails_helper'

RSpec.describe ArtifactsController, type: :controller do

  let(:user) { FactoryGirl.build(:user) }

  describe "GET #new" do
    before(:each) do
      login(user)
    end

    it "when entry in page to choose the artifact that should be create" do
      get :new
      expect(response).to render_template("new")
    end

    it "to load all @artifacts avaliable in system" do
      get :new
      expect(assigns(:artifacts)).to_not be_empty
    end

  end

  describe "GET #new_type" do

    before(:each) do
      login(user)
    end

    it "when render right page" do
      project = FactoryGirl.build(:project)
      project.save!

      get :new_type, params: { id: project.id, type: 'note' }
      expect(response).to render_template("notes/new")
    end

    it "when call inexistent artifact" do
      project = FactoryGirl.build(:project)
      project.save!

      get :new_type, params: { id: project.id, type: 'XGH' }
      expect(response).to render_template("layouts/error")
    end

  end

end
