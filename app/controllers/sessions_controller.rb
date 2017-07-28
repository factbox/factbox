class SessionsController < ApplicationController

  # POST /sessions
  # Login - Creates user session
  def create
    user = User.find_by(login: params[:login])

    session[:user_id] = user.id if user && user.authenticate(params[:password])

    redirect_to root_url
  end

  # DELETE /sessions/:id
  # Logout - Destroy user session
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
