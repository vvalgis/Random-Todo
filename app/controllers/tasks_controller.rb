class TasksController < ApplicationController
  def index
    @tasks = Task.is_waiting
  end
  
  def finished
    @tasks = Task.has_done
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
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = "Successfully destroyed task."
    redirect_to tasks_url
  end
end
