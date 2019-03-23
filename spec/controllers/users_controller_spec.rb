require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.build(:user) }

  describe 'GET #index' do
    it 'without login should render the index page' do
      get :index
      expect(response).to render_template('index')
    end

    it 'when logged in' do
      user.save!
      login(user)

      get :index
      expect(response).to redirect_to('/projects')
    end
  end

  describe 'POST #create' do
    it 'when creates a valid user' do
      user_params = {
        user: FactoryBot.attributes_for(:user)
      }
      expect { post :create, params: user_params }
        .to change(User, :count).by(1)

      expect(response).to render_template('sucessful_register')
    end

    it 'when creates an invalid user' do
      user_params = {
        user: {
          email: 'lorem@ipsum.com',
          name: 'T',
          lastName: 'L',
          login: 'test',
          password: '12',
          password_confirmation: '12'
        }
      }
      expect { post :create, params: user_params }
        .to change(Project, :count).by(0)

      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    it 'when logged in' do
      user.save!
      login(user)

      get :show, params: { login: 'userSample' }
      expect(response).to render_template('show')
    end
  end
end
