require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "GET #index" do
    let(:user) { FactoryGirl.build(:user) }

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
      login(FactoryGirl.build(:user))
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

end
