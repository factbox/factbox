require 'rails_helper'

RSpec.describe ArtifactsController, type: :controller do

  let(:user) { FactoryBot.build(:user) }

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
      project = FactoryBot.build(:project)
      project.save!

      get :new_type, params: { id: project.id, type: 'note' }
      expect(response).to render_template("notes/new")
    end

    it "when call inexistent artifact" do
      project = FactoryBot.build(:project)
      project.save!

      get :new_type, params: { id: project.id, type: 'XGH' }
      expect(response).to render_template("layouts/error")
    end

  end

  describe "GET #edit" do
    before(:each) do
      login(user)
    end

    it "when entry in edit page" do
      note = FactoryBot.build(:note)
      note.save!

      get :edit, params: { id: note.id, type: 'note' }
      expect(response).to render_template("edit")
    end

  end

  describe "POST #create" do

    let(:project) { FactoryBot.build(:project) }

    before(:each) do
      user.save!
      project.save!
      login(user)
    end

    it "when params is valid" do
      post :create, params: {
        artifact: {
          type: 'note',
          project_id: project.id,
          title: 'Simple note',
        }
      }

      expect(response).to redirect_to("/projects/#{project.id}")
    end

    it "when params is invalid" do
      post :create, params: {
        artifact: {
          type: 'note',
          project_id: project.id,
        }
      }

      expect(response).to render_template("notes/new")
    end

    it "when artifact type is not defined" do
      post :create, params: {
        artifact: {
          title: 'Simple note',
          description: 'Simple note',
          project_id: project.id
        }
      }

      expect(response).to render_template("layouts/error")
    end

  end

  describe "POST #update" do

    let(:note) { FactoryBot.create(:note) }
    let(:attr) do
      { type: 'note', project_id: 1, title: 'Simple note' }
    end

    before(:each) do
      user.save!
      login(user)
    end

    it "when params is valid" do
      put :update, params: { id: note.id, artifact: attr }

      # Id is (note.id + 1) because this would be the new artifact version id...
      expect(response).to redirect_to action: :edit, id: note.id + 1, type: 'note'
    end
  end

  describe "GET #show" do
    it "render page" do
      note = FactoryBot.build(:note)
      note.save!

      get :show, params: { project_id: note.project_id, title: note.title }
      expect(response).to render_template("notes/show")
      expect(assigns(:artifact).specific).to eq(note)
    end
  end

end
