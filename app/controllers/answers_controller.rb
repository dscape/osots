class AnswersController < ApplicationController
  before_filter :login_required
  before_filter :find_exam_session

  def new
    if @exam_session.nil?
      redirect_to prepare_exam_path
    else
      current_question = @exam_session.current_question
      
      # this will happen if the user navigates to this url without preparing the exam. So we can link to last exam result here.
      if @exam_session.exam.nr_questions == current_question + 1
        flash[:notice] = 'You have finished the test.'
        redirect_to result_path @exam_session.id
      # this is also for the case of user forgery.
      elsif @exam_session.exam.total_time.minutes != 0 && @exam_session.created_at + @exam_session.exam.total_time.minutes < Time.now 
        flash[:warning] = 'Time is up. Here are your results.'
        redirect_to result_path @exam_session.id
      else
        @question = @exam_session.exam.questions.find :first, :offset => (current_question - 1)
        @exam_session.update_attribute(:updated_at, Time.now)
      end
    end
  end
  
  def create
    #increment current question
    # will only submit if time not passed
  end
  
  protected
  def find_exam_session
    @exam_session = ExamSessions.find :first, :order => 'exam_sessions.created_at desc', :conditions =>  "user_id = #{current_user.id}", :include => :exam
  end
end