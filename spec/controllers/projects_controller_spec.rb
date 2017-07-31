require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  let(:user) { FactoryGirl.build(:user) }

  describe "GET #index" do
    before(:each) do
      user.save!
      login(user)
    end

    it "get all @user_projects" do
      get :index
      expect(assigns(:user_projects)).to eq(user.projects)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #new" do
    before(:each) do
      login(user)
    end

    it "loads empty object into new page" do
      get :new
      expect(assigns(:project)).to_not eq(nil)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    before(:each) do
      user.save!
      login(user)
    end

    it "creates a valid project" do
      expect {
        post :create, params: {
          project: {
            name: "New project",
            description: "Just a test"
          }
        }
      }.to change(Project, :count).by(1)

      expect(response).to redirect_to("/projects")
    end

    it "try creates an invalid project" do
      expect {
        post :create, params: {
          project: {
            description: "Just a test"
          }
        }
      }.to change(Project, :count).by(0)

      expect(response).to render_template("new")
    end
  end

end
