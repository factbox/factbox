class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
      session[:user_id]
    end

    def authorize
      redirect_to root_path unless logged_in?
    end

    helper_method :current_user, :logged_in?, :authorize
end
