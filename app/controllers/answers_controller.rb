class AnswersController < ApplicationController
  before_filter :login_required
  before_filter :find_exam_session
  before_filter :exam_session_is_valid
  before_filter :exam_session_is_not_finished, :only => :new

  def new
    @question = @exam_session.exam.questions.find :first, :offset => (@exam_session.current_question - 1)
    @exam_session.update_attribute(:updated_at, Time.now)
    
    # override with purexml
    @choices = {'choiceA' => 'Compact', 'choiceB' => 'Typical', 'choiceC' => 'Response File', 
                  'choiceD' => 'Custom', 'choiceE' => 'A and B'}
  end
  
  def create
    # increment current question (1)
    @exam_session.increment! :current_question

   if @exam_session.exam.per_question != 0 && @exam_session.updated_at + @exam_session.exam.per_question.minutes < Time.now
     flash[:warning] = 'Your answer was not considered. Time limit for the question passed!'
     redirect_to current_question_path
   else
     # because it was incremented in (1)
     @question = @exam_session.exam.questions.find :first, :offset => (@exam_session.current_question - 2) # 0th based
     Answers.create :exam_session_id => @exam_session.id, 
                   :question_id => @question.id,
                   :option => params[:answer]
                   
     @exam_session.exam.total_time == 0 ?
       finish_string = "" :
       finish_string = " Exam will end in<strong> " +
                       "#{ActionView::Helpers::DateHelper.time_ago_in_words(@exam_session.created_at + @exam_session.exam.total_time.minutes,true)}" +
                       "</strong>."
     @exam_session.exam.per_question == 0 ?
       time_question = "" :
       time_question = " You have <strong>#{@exam_session.exam.per_question}</strong> minutes for this question"
       
     flash[:ok] = "Answer <strong>accepted</strong>." + finish_string + time_question
     redirect_to current_question_path
   end
  end

  protected
  def find_exam_session
    @exam_session = ExamSessions.find :first,
                                      :order => 'exam_sessions.created_at desc',
                                      :conditions =>  "user_id = #{current_user.id}", 
                                      :include => :exam
  end
  
  def exam_session_is_valid
     (@exam_session.nil? || @exam_session.finished) ? redirect_to(prepare_exam_path) : true
  end
  
  def exam_session_is_not_finished
    if @exam_session.exam.nr_questions < @exam_session.current_question
      flash[:notice] = 'You have finished the test.'
      render_results
    elsif @exam_session.exam.total_time != 0 && @exam_session.created_at + @exam_session.exam.total_time.minutes < Time.now 
      flash[:warning] = 'Time is up. Here are your results.'
      render_results
    else
      true
    end
  end

  
  def render_results
    # set finished to true
    @exam_session.update_attribute :finished, :true
    # render results
    redirect_to result_path @exam_session.id
  end

end