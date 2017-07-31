module SpecLoginHelper
  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    User.find(request.session[:user])
  end

  def logged_in?
    session[:user_id]
  end

  def authorize
    # Do nothing
  end

end
