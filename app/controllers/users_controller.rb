class UsersController < ApplicationController
  def index
  end

  def create
    @user = UrutaUser.new(user_params)
    if @user.save
      redirect_to root_url
    else
      render :new
    end
  end

  def authenticate
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :lastName, :login, :password_digest)
  end

end
