# Controller for users actions
class UsersController < ApplicationController
  # Control of index dependent of user login
  # GET /
  def index
    if logged_in?
      redirect_to '/projects'
    else
      @user = User.new
      render layout: 'unstyled'
    end
  end

  # Register new users
  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render 'sucessful_register'
    else
      render :index, layout: 'unstyled'
    end
  end

  # Page with user settings
  # GET /user/settings
  def settings; end

  # GET  /users/:login
  def show
    # Result is a array, login should refers to unique user
    result = User.where(login: params[:login])

    # Throws invalid duplication error
    if result.length != 1
      raise NotImplementedError, 'System keep 2 user with same login!'
    end

    @user = result.first
  end

  private

  def user_params
    params.require(:user)
      .permit(:email, :name, :lastName, :login, :password, :password_confirmation)
  end

end
