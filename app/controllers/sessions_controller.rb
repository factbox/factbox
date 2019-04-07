# Controller for users session
class SessionsController < ApplicationController
  # POST /sessions
  # Login - Creates user session
  def create
    user = User.find_by(login: params[:login])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
    else
      flash[:notice] = 'Invalid credentials'
    end

    redirect_to root_url
  end

  # DELETE /sessions/:id
  # Logout - Destroy user session
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Successfull logout'
  end
end
