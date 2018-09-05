class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
    def current_user
      begin
        db_user = User.find(session[:user_id])
        @current_user ||= db_user if session[:user_id]
      rescue ActiveRecord::RecordNotFound
        @current_user = nil
      end
    end

    def logged_in?
      session[:user_id]
    end

    def authorize
      redirect_to root_path unless logged_in?
    end

    def redirect_to_error_page(msg)
      @message = msg
      render 'layouts/error'
    end

    helper_method :current_user, :logged_in?, :authorize
end
