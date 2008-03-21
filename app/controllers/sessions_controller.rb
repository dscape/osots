# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  def new
    redirect_to root_path
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      current_user.update_attribute(:last_login_at, Time.now)
      redirect_back_or_default('/')
      flash[:ok] = "Signed in successfully"
    else
      flash[:error] = 'Authentication failed.'
      redirect_to root_path
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Signed out successfuly."
    redirect_back_or_default('/')
  end
end
