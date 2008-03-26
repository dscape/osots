class ResultsController < ApplicationController
  before_filter :login_required, :only => :show_or_create
  before_filter :exam_session_is_valid, :only => :show_or_create
  before_filter :fecth_class_vars, :only => :show_or_create
  
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
        redirect_to result_path params[:id]
      else
        flash[:warning] = 'Sorry, you failed. You can try again in seven days.'
        redirect_to result_path params[:id]
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
  
  def show
    unless owns_profile?
      flash[:error] = 'You cannot see this result because it belongs to another user.'
      redirect_to root_path
    end
  end


  def prepare_result
    @min = 65 # 65%
    
    @correct = []
    
    @questions.each do |question|
      correct_option = 'choiceA' # get from DB2
      answer_for_question = @answers.select { |a| a.question_id == question.id }.first

      # unless the user has no answer
      if !answer_for_question.nil? && answer_for_question.option == correct_option
        @correct << question.id
      end
    end
    
    @result.score = (@correct.size * 100 / @exam.nr_questions).to_i
    
    if @result.score >= @min
       @result.passed = true
    end
  end
  
  def fecth_class_vars
    @answers = Answers.find :all, :conditions => "exam_session_id = #{@exam_session.id}"
    @exam = @exam_session.exam
    @questions = @exam.questions
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

  def owns_profile?
    current_user.id == @result.user_id
  end
end
