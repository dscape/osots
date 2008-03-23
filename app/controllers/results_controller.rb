class ResultsController < ApplicationController
  before_filter :login_required, :only => :show_or_create
  before_filter :exam_session_is_valid, :only => :show_or_create
  before_filter :own_profile, :only => :show
  
  def show_or_create
    find_or_initialize_result
    @result.new_record? ? create : show
  end
  
  private

  def create
    prepare_result
    
    if @result.save
      if @result.passed
        flash[:ok] = 'Congratulations! You passed'
        # redirect do the certificate
        redirect_to root_path #comment this
      else
        flash[:warning] = 'Sorry, you failed. You can try again in seven days.'
        # redirect do the certificate
        redirect_to root_path #comment this
      end
    else
      flash[:error] = 'Error processing result. Please start again.'
      
      es = ExamSessions.find :first,
                             :order => 'created_at desc',
                             :conditions =>  "user_id = #{current_user.id}"
                                        
      # user can't be blamed for this. so we give them the test back
      es.destroy
      redirect_to root_path
    end
  end

  def prepare_result
    answers = Answers.find :all, :conditions => "exam_session_id = #{@exam_session.id}"
    questions = @exam_session.exam.questions
    
    correct = wrong = []
    
    if answers.size > questions.size
      flash[:error] = 'An error occurred. Please try again later.'
      redirect_to root_path
    end
    
    questions.each do |question|
      correct_option = 'choiceA' # get from DB2
      
    end

  end

  def show
    render :text => 'show'
  end
  
  def exam_session_is_valid
     @exam_session = ExamSessions.find_by_id params[:id], :limit => 1
     if @exam_session.nil?
       flash[:error] = 'That exam result does not exist.'
       redirect_to root_path
     else
       true
     end
  end
  
  def find_or_initialize_result
    @result = Result.find_or_initialize_by_exam_session_id params[:id]
  end

  def own_profile
    unless current_user.id == @result.user_id
      flash[:error] = 'You cannot see this result because it belongs to another user.'
      redirect_to root_path
    else
      return true
    end
  end
end