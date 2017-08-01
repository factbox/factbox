require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let(:user) { FactoryGirl.build(:user) }

  describe "POST #create" do
    before(:each) do
      user.save!
    end

    it "when user is valid" do
      post :create, params: { login: user.login, password: user.password }
      expect(request.session[:user_id]).to eq(user.id)
    end

    it "when user data is invalid" do
      post :create, params: { login: user.login, password: 'wrong' }
      expect(request.session[:user_id]).to eq(nil)
    end

  end

  describe "DELETE #destroy" do
    before(:each) do
      user.save!
      login(user)
    end

    it "when user is logged" do
      delete :destroy
      expect(request.session[:user_id]).to eq(nil)
    end
  end

end
