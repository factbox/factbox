class UsersController < ApplicationController
  def index
    if logged_in?
        redirect_to '/projects'
    else
      @user = UrutaUser.new
      render layout: "unstyled"
    end
  end

  def create
    @user = UrutaUser.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render 'sucessful_register'
    else
      render :index, layout: "unstyled"
    end
  end

  private

  def user_params
    params.require(:uruta_user)
      .permit(:email, :name, :lastName, :login, :password, :password_confirmation)
  end

end
