class TasksController < ApplicationController
  before_filter :check_free_time
  def index
    @tasks = Task.is_waiting.order('updated_at DESC') 
  end
  
  def finished
    @tasks = Task.has_done
  end
  
  def next
    @task = Task.urgent.for_current_daypart.not_in_progress.in_time(@free_time).rand
    unless @task
      @task = Task.urgent.not_in_progress.in_time(@free_time).rand
      unless @task
        @task = Task.for_current_daypart.not_in_progress.in_time(@free_time).rand
        unless @task
          @task = Task.for_any_daypart.is_waiting.not_in_progress.in_time(@free_time).rand
        end
      end
    end
    respond_to do |format|
      format.js { render :task, :locals => { :update => :next_task }}
    end    
  end
  
  def in_progress
    @task = Task.urgent.for_current_daypart.in_progress.in_time(@free_time).rand
    unless @task
      @task = Task.urgent.in_progress.in_time(@free_time).rand
      unless @task
        @task = Task.for_current_daypart.in_progress.in_time(@free_time).rand
        unless @task
          @task = Task.for_any_daypart.is_waiting.in_progress.in_time(@free_time).rand
        end
      end
    end
    respond_to do |format|
      format.js { render :task, :locals => { :update => :in_progress }}
    end    
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(params[:task])
    if @task.save
      flash[:notice] = "Successfully created task."
      redirect_to tasks_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      flash[:notice] = "Successfully updated task."
      redirect_to tasks_url
    else
      render :action => 'edit'
    end
  end
  
  def i_have_done
    @task = Task.find(params[:id])
    if @task.update_attributes(:in_progress => false, :is_done => true)
      flash[:notice] = "Successfully updated task."
    else
      flash[:error] = "Something goes wrong."
    end
    redirect_to root_path
  end
  
  def i_will_do
    @task = Task.find(params[:id])
    if @task.update_attributes(:in_progress => true)
      flash[:notice] = "Successfully updated task."
    else
      flash[:error] = "Something goes wrong."
    end
    redirect_to root_path
  end

  def restore
    @task = Task.find(params[:id])
    if @task.update_attributes(:in_progress => false, :is_done => false)
      flash[:notice] = "Successfully updated task."
    else
      flash[:error] = "Something goes wrong."
    end
    redirect_to root_path
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = "Successfully destroyed task."
    redirect_to tasks_url
  end
  
  private
    def check_free_time
      @free_time = (session[:free_time] ||= 15).to_i
    end
  
end
