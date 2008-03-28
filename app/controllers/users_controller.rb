class UsersController < ApplicationController
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :edit, :update, :change_password, :show]

  before_filter :login_required, :only => :show
  before_filter :authorization_required, :only => [:change_roles, :suspend, :unsuspend, :destroy, :purge]
  before_filter :own_profile, :only => [:edit, :update, :change_password]

  def index
    @users = User.find :all
  end

  def show
  end

  def edit
  end
  
  def update
   if @user.update_attributes params[:user]
     flash[:ok] = 'Profile updated.'
     redirect_to(@user)
   else
     flash[:error] = 'Profile update failed.'
     render :action => "edit"
   end
  end

  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new params[:user]
    @user.register! if @user.valid?
    if @user.errors.empty?
      #self.current_user = @user
      redirect_to root_path
      flash[:warning] = "Thanks for signing up! Check your email for further instructions."
    else
      render :action => 'new'
    end
  end
  
  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      current_user.update_attribute(:last_login_at, Time.now)
      flash[:ok] = "Signup complete!"
    else
      flash[:error] = "The activation code you provided is wrong. Please try again."
    end
    redirect_back_or_default('/')
  end

  def suspend
    flash[:notice] = "User #{@user.login} was suspended."
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    flash[:notice] = "User #{@user.login} was unsuspended."
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    flash[:notice] = "User #{@user.login} was deleted."
    @user.delete!
    redirect_to users_path
  end

  def purge
    flash[:notice] = "User #{@user.login} was purged."
    @user.destroy
    redirect_to users_path
  end
  
  # this is root only.
  # dont add to permission of other user type (contributor, ambassador, etc)
  def change_roles
    @user = User.find params[:id], :include => :roles
    roles = @user.roles
    db_roles_ids = roles.map { |i| i.id.to_s }
    if request.put?
      params[:roles_ids] ||= []
      user_roles_ids = params[:roles_ids]
      if params[:roles_ids] == []
        flash[:notice] = "roles have been reseted for user"
        roles.delete_all
      else
        flash[:notice] = "roles changed for this user"
        to_delete = db_roles_ids.reject { |i| params[:roles_ids].member? i }
        to_put = params[:roles_ids].reject { |i| db_roles_ids.member? i }

        # avoid mass assignment
        # user can only change roles here.
        # don't act smart and change this to a one-liner and create a major bug in the system.
        # yes code can be improved. but it was made like this thinking in security
        to_put.each do |role_id|
          r = Role.find_by_id(role_id) 
          roles << r unless r.nil? 
        end
       
        to_delete.each do |role_id| 
          r = Role.find_by_id role_id
          roles.delete r unless r.nil?
        end
      end
    end
  end
  
  def change_password
    if request.put?
      valid = User.authenticate(@user.login, params[:user][:old_password])
      if valid
        unless params[:user][:password].blank? || params[:user][:password_confirmation].blank?
          if @user.update_attributes params[:user]
            flash[:ok] = 'Password changed.'
            redirect_to(@user)
          else
            flash[:error] = 'Operation failed!'
            render :action => 'change_password'
          end                  
        else
          flash[:warning] = 'You forgot to mention the new password.'
          render :action => 'change_password'         
        end                    
      else                     
        flash[:error] = 'The password you provided was wrong.'
        render :action => 'change_password'
      end                      
    end         
  end       
  
  def reset_password
    self.current_user = params[:password_reset_code].blank? ? false : User.find_by_password_reset_code(params[:password_reset_code])
    if logged_in?
      if request.put?
        unless params[:user][:password].blank? || params[:user][:password_confirmation].blank?
          if current_user.update_attributes params[:user]
            current_user.update_attribute(:password_reset_code, nil)
            flash[:ok] = 'Password changed.'
            redirect_to(current_user)
          else
            flash[:error] = 'Operation failed!'
            render :action => 'reset_password' 
          end                  
        else
          flash[:warning] = 'You forgot to mention the new password.'
          render :action => 'reset_password'         
        end
      end
    else
      flash[:error] = "The activation code you provided is wrong. Please try again."
      redirect_to root_path
    end
  end   
  
  def recover_password
    if request.put?
      unless params[:user][:login].blank? && params[:user][:email].blank?
        params[:user][:login].blank? ? user = User.find_by_email(params[:user][:email]) : user = User.find_by_login(params[:user][:login])
        unless user.nil?
          flash[:ok] = 'Instruction on how to get your password back have been mailed to you'
          user.update_attribute(:password_reset_code, Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join ))
          redirect_to root_path
        else
          flash[:warning] = 'You made a mistake while typing. Please try again.'
          render :action => 'recover_password'
        end
      else
        flash[:error] = 'You must provide at least one field.'
        render :action => 'recover_password'
      end
    end
  end   

  protected
    def find_user
      @user = User.find params[:id]
    end
    
    def own_profile
      unless current_user.nil? || @user.nil?
        if @user.id == current_user.id || has_root?
          true
        else
          flash[:error] = 'You can only edit your own profile.'
          access_denied
        end
      else
        flash[:error] = 'You must start a new session to edit your profile.'
        access_denied
      end
    end
end
