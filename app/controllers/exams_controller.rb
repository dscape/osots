class ExamsController < ApplicationController
  before_filter :authorization_required, :except => :prepare_exam
  before_filter :login_required, :only => :prepare_exam
  before_filter :user_can_take_exam, :only => :prepare_exam

  def prepare_exam
    exams = Exam.find :all
    
    # select one random exam
    rand_exam_id = exams[rand(exams.size)].id
    
    # create new exam session
    exam_session = ExamSessions.new :user_id => current_user.id, :exam_id => rand_exam_id
    
    if exam_session.save
      flash[:ok] = 'Goodluck with your test'
      redirect_to current_question_path
    else
      flash[:error] = 'Please try again'
      redirect_to root_path
    end
  end

  def index
    @exams = Exam.find :all
  end

  def new
    @exam = Exam.new
  end

  def create
    min_questions = 5
    
    params[:exam][:question_ids] ||= []
    params[:exam][:nr_questions] = params[:exam][:question_ids].size
    params[:exam][:per_question] = params[:exam][:per_question].to_i
    params[:exam][:total_time] = params[:exam][:total_time].to_i

    @exam = Exam.new params[:exam]

    if params[:exam][:nr_questions] < min_questions
      flash[:error] = "You must provide at least #{min_questions} questions for each exam"
      render :action => 'new'
    else
      if @exam.save
        flash[:ok] = 'Exam was successfully created.'
        redirect_to(@exam)
      else
        render :action => "new"
      end
    end
  end
  
  def show
    @exam = Exam.find params[:id]
    @questions = Exam.find_questions_by_exam_id(params[:id]).group_by(&:topic)
  end
  
  def edit
    @exam = Exam.find params[:id], :include => :questions
    @questions = @exam.questions
  end

  def update
    min_questions = 5
    
    params[:exam][:question_ids] ||= []
    params[:exam][:nr_questions] = params[:exam][:question_ids].size
    params[:exam][:per_question] = params[:exam][:per_question].to_i
    params[:exam][:total_time] = params[:exam][:total_time].to_i

    @exam = Exam.find params[:id]

    if params[:exam][:nr_questions] < min_questions
      flash[:error] = "You must provide at least #{min_questions} questions for each exam"
      render :action => 'new'
    else
      if @exam.update_attributes params[:exam]
        flash[:ok] = 'Exam was successfully updated.'
        redirect_to @exam
      else
        render :action => "new"
      end
    end
  end
  
  def destroy
    @exam = Exam.find params[:id]
    @exam.destroy

    flash[:notice] = 'Exam destroyed.'
    redirect_to exams_url
  end
  
  protected
  def user_can_take_exam
    last_exam_session  = ExamSessions.find :first, :order => 'created_at desc', :conditions =>  "user_id = #{current_user.id}"
    exam_sessions_count = ExamSessions.count :conditions =>  "user_id = #{current_user.id}"

    if exam_sessions_count == 0
      true
    elsif exam_sessions_count >= 3
      flash[:error] = 'You failed three times and cannot take the exam.'
      redirect_to result_path last_exam_session.id
    elsif last_exam_session.created_at + 7.days > Time.now
      flash[:warning] = "You have to wait #{ActionView::Helpers::DateHelper.time_ago_in_words(last_exam_session.created_at + 7.days)} to take a new exam."
      redirect_to result_path last_exam_session.id
    else
      true
    end
  end
  
end
