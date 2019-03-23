require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }

  describe 'GET #index' do
    it 'when logged in should get all user projects' do
      login(user)

      get :index
      expect(assigns(:user_projects)).to eq(user.projects)
    end

    it 'when logged out should go to the index' do
      get :index
      expect(response).to redirect_to('/')
    end
  end

  describe 'GET #new' do
    before(:each) do
      login(user)
    end

    it 'loads empty object into new page' do
      get :new
      expect(assigns(:project)).to_not eq(nil)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'GET #show' do
    before(:each) do
      login(user)
    end

    # Work just in prod
    it 'when not have plugins' do
      get :show, params: { id: project.id }

      expect(assigns(:plugins).size).to eq(0)
    end
  end

  describe 'GET #traceability' do
    let(:note1) { FactoryBot.create(:note, project_id: project.id) }
    let(:note2) { FactoryBot.create(:note, title: 'Another Note', source: note1, project_id: project.id) }
    let(:note3) { FactoryBot.create(:note, title: 'Lorem ipsum', source: note1, project_id: project.id) }

    it 'when project have 3 nodes and 2 edges' do
      notes = [note1, note2, note3]
      get :traceability, params: { id: project.id }

      expect(assigns(:nodes).size).to eq(notes.size)
    end
  end

  describe 'POST #create' do
    before(:each) do
      user.save!
      login(user)
    end

    it 'creates a valid project' do
      project_params = {
        project: {
          name: 'New project',
          description: 'Just a test'
        }
      }
      expect { post :create, params: project_params }
        .to change(Project, :count).by(1)

      expect(response).to redirect_to('/projects')
    end

    it 'try creates an invalid project' do
      project_params = {
        project: {
          description: 'Just a test'
        }
      }
      expect { post :create, params: project_params }
        .to change(Project, :count).by(0)

      expect(response).to render_template('new')
    end
  end

  describe 'PUT #update' do
    it 'do a valid update' do
      project = FactoryBot.build(:project)
      project.save!

      put :update, params: {id: project.id, project: { name: 'A valid title' }}

      project.reload
      expect(project.name).to eq('A valid title')
    end

    it 'do a invalid update' do
      project = FactoryBot.build(:project)
      project.save!

      put :update, params: {id: project.id, project: { name: '' }}

      expect(response).to render_template('edit')
    end
  end
end
