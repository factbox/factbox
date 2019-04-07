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

  def update
    # Fetch user data from database
    @user = User.find(current_user.id)

    if @user.update_attributes(user_params)
      flash[:success] = 'User updated with success'
    end
    render 'settings'
  end

  # Page with profile settings
  # GET /user/settings
  def settings; end

  # Page with sensitive account settings like
  # account delete and password confirmation
  # GET /user/settings/account
  def settings_account; end

  def update_password
    authenticated = current_user.authenticate(password_params[:old_password])
    password_data = password_params.except(:old_password)
    if authenticated
      if current_user.update_attributes(password_data)
        flash[:success] = 'Password successfully updated.'
      else
        flash[:danger] = 'Password confirmation is invalid'
      end
    else
      flash[:danger] = 'The current password are wrong.'
    end
    render 'settings_account'
  end

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
          .permit(:email, :name, :lastName, :login, :password,
                  :password_confirmation, :avatar)
  end

  def password_params
    params.require(:user)
          .permit(:password, :password_confirmation, :old_password)
  end
end
