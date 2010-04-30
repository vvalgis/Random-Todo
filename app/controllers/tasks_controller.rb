class TasksController < ApplicationController
  before_filter :check_free_time, :only => [ :next, :next_delayed ]
  before_filter :authenticate_user! 
  def index
    #@tasks = Task.where('status = ? OR status = ?', Task::WAITING, Task::DELAYED).order('updated_at DESC') 
    @tasks = current_user.tasks.is_waiting.order('updated_at DESC') 
  end
  
  def finished
    @tasks = current_user.tasks.has_done
  end
  
  def delayed
    @tasks = current_user.tasks.delayed.order('updated_at DESC')
    render :index
  end
  
  def next
    @task = current_user.tasks.urgent.for_current_daypart.is_waiting.in_time(@free_time).rand
    unless @task
      @task = current_user.tasks.urgent.is_waiting.in_time(@free_time).rand
      unless @task
        @task = current_user.tasks.for_current_daypart.is_waiting.in_time(@free_time).rand
        unless @task
          @task = current_user.tasks.for_any_daypart.is_waiting.in_time(@free_time).rand
        end
      end
    end
    if @task
      Task.update_all({:status => Task::DELAYED}, {:user_id => current_user.id, :status => Task::IN_PROGRESS})
      @task.update_attribute(:status, Task::IN_PROGRESS)
    else
      flash[:notice] = 'No tasks affordable to your amount of time'
    end
    respond_to do |format|
      format.html { redirect_to :root }
      format.js { render :task, :locals => { :update => :next_task }}
    end    
  end
  
  def next_delayed
    @task = current_user.tasks.urgent.for_current_daypart.delayed.in_time(@free_time).rand
    unless @task
      @task = current_user.tasks.urgent.delayed.in_time(@free_time).rand
      unless @task
        @task = current_user.tasks.for_current_daypart.delayed.in_time(@free_time).rand
        unless @task
          @task = current_user.tasks.for_any_daypart.delayed.in_time(@free_time).rand
        end
      end
    end
    if @task
      Task.update_all({:status => Task::DELAYED}, {:user_id => current_user.id, :status => Task::IN_PROGRESS})
      @task.update_attribute(:status, Task::IN_PROGRESS)
    else
      flash[:notice] = 'No tasks affordable to your amount of time'
    end
    respond_to do |format|
      format.html { redirect_to :root }
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
    @task = current_user.tasks.build(params[:task])
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
    if @task.update_attribute(:status, Task::DONE)
      flash[:notice] = "Successfully updated task."
    else
      flash[:error] = "Something goes wrong."
    end
    redirect_to root_path
  end
  
  def delay
    @task = Task.find(params[:id])
    if @task.update_attribute(:status, Task::DELAYED)
      flash[:notice] = "Successfully updated task."
    else
      flash[:error] = "Something goes wrong."
    end
    redirect_to root_path
  end

  def restore
    @task = Task.find(params[:id])
    if @task.update_attribute(:status, Task::WAITING)
      flash[:notice] = "Successfully updated task."
    else
      flash[:error] = "Something goes wrong."
    end
    @finished_count = current_user.tasks.has_done.count
    respond_to do |format|
      format.html { redirect_to finished_tasks_path }
      format.js
    end
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
