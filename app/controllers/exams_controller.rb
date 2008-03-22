class ExamsController < ApplicationController
  before_filter :authorization_required

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
    @exam = Exam.find params[:id], :include => :questions
    @questions = @exam.questions
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
  
end