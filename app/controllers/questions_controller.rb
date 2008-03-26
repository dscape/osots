class QuestionsController < ApplicationController
  before_filter :authorization_required, :except => :index

  def index
    @questions = Question.find_all_and_return_xml_table.group_by(&:topic) if authorized?
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(params[:question])

    if @question.save
      flash[:ok] = 'Question was successfully created.'
      redirect_to(@question)
    else
      render :action => "new"
    end
  end

  def update
    @question = Question.find(params[:id])

    if @question.update_attributes(params[:question])
      flash[:notice] = 'Question was successfully updated.'
      redirect_to(@question)
    else
      flash[:error] = 'Could not update the question.'
      render :action => "edit"
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    flash[:notice] = 'Question destroyed.'
    redirect_to(questions_url)
  end
end
