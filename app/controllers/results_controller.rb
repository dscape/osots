class ResultsController < ApplicationController
  before_filter :login_required
  
  def create
    # will need to get the hash with response to each question
    # and eval if the result is better than 65%
    # that should be stored in a bool var named pass.
    # the rest of the controller is ok! :)
    nr_res = Result.count(:conditions => "user_id = #{current_user.id}"
    
    if nr_res < 3
      last_date = Result.find(:first, :order => 'created_at desc', :conditions =>  "user_id = #{current_user.id}").created_at
      if((Time.now - last_date) > 7.days)
        @result = Result.new #params[:result]
        
        if @result.save
          if passed
            flash[:ok] = 'Congratulations! You passed'
            # redirect do the certificate
            redirect_to root_path #comment this
          else
            flash[:ok] = 'Sorry, you failed. You can try again in seven days.'
            # redirect do the certificate
            redirect_to root_path
          end
        else
          render :action => "new"
        end
      else
        flash[:error] = 'You have to wait seven days from your last exam.'
        redirect_to root_path
      end
    else
      flash[:error] = 'Sorry you already used all of your chances to do this test.'
      redirect_to root_path
    end
  end
end