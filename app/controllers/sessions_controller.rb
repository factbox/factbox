class SessionsController < ApplicationController

  def create
    user = User.find_by(login: params[:login])

    session[:user_id] = user.id if user && user.authenticate(params[:password])

    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
