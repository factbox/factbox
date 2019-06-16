require 'rails_helper'

RSpec.describe ArtifactsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:project) {
    p = FactoryBot.create(:project)
    p.users = [user]
    p.save!
    return p
  }

  describe 'GET #new' do
    before(:each) do
      login(user)
    end

    it 'when entry in page to choose the artifact that should be create' do
      get :new, params: { project_name: project.uri_name }
      expect(response).to render_template('new')
    end

    it 'to load all @artifacts avaliable in system' do
      get :new, params: { project_name: project.uri_name }
      expect(assigns(:artifacts)).to_not be_empty
    end
  end

  describe 'GET #new_type' do
    before(:each) do
      login(user)
    end

    it 'when render right page' do
      get :new_type, params: { name: project.uri_name, type: 'note' }
      expect(response).to render_template('notes/new')
    end

    it 'when call inexistent artifact' do
      get :new_type, params: { name: project.uri_name, type: 'XGH' }
      expect(response).to render_template('layouts/error')
    end
  end

  describe 'GET #edit' do
    let(:note) { FactoryBot.create(:note, project_id: project.id) }

    before(:each) do
      login(user)
    end

    it 'when entry in edit page' do
      get :edit, params: { project_name: project.uri_name, type: 'note',
                           title: note.uri_name }
      expect(response).to render_template('edit')
    end
  end

  describe 'POST #create' do
    before(:each) do
      user.save!
      login(user)
    end

    it 'when params is valid' do
      post :create, params: {
        artifact: {
          type: 'note',
          project_id: project.id,
          title: 'Simple note'
        }
      }
      expect(response).to redirect_to("/projects/#{project.uri_name}")
    end

    it 'when params is invalid' do
      post :create, params: {
        artifact: {
          type: 'note',
          project_id: project.id
        }
      }
      expect(response).to render_template('notes/new')
    end

    it 'when artifact type is not defined' do
      post :create, params: {
        artifact: {
          title: 'Simple note',
          description: 'Simple note',
          project_id: project.id
        }
      }
      expect(response).to render_template('layouts/error')
    end
  end

  describe 'POST #update' do
    let(:note) { FactoryBot.create(:note, project_id: project.id) }

    let(:attr) do
      { type: 'note', project_id: project.id, title: 'Simple note' }
    end

    before(:each) do
      login(user)
    end

    it 'when params is valid' do
      put :update, params: { id: note.id, artifact: attr }
      # Id is (note.id + 1) because this would be the new artifact version id...
      expect(response).to have_http_status(302)
    end
  end

  describe 'GET #show' do
    let(:note) { FactoryBot.create(:note, project_id: project.id) }
    it 'render page' do
      get :show, params: { project_name: project.uri_name, title: note.title }
      expect(response).to render_template('notes/show')
      expect(assigns(:artifact).specific).to eq(note)
    end
  end

  describe 'GET #show_versions' do
    let(:first_note) { FactoryBot.create(:note, project_id: project.id) }
    let(:second_version) do
      FactoryBot.create(:note, title: 'Updated Note',
                               origin_artifact: first_note,
                               project_id: project.id)
    end
    let(:last_version) do
      FactoryBot.create(:note, title: 'Last version',
                               origin_artifact: second_version,
                               project_id: project.id)
    end

    it 'when artifact has 3 versions' do
      artifact_params = {
        project_name: project.name,
        title: last_version.title
      }
      versions = [first_note, second_version, last_version]
      get :show_versions, params: artifact_params

      expect(assigns(:versions).size).to eq(versions.size)
      expect(response).to render_template('show_versions')
    end
  end
end
