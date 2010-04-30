class HomeController < ApplicationController
  def dashboard
    if user_signed_in?
      @current_task = Task.in_progress.first
      @tasks_finished = Task.has_done.limit(7)
      @finished_count = Task.has_done.count
      @delayed_count = Task.delayed.count
    else
      render :text => '', :layout => true
    end
  end
  
  def set_free_time
    session[:free_time] = params[:time]
    render :partial => 'shared/flash', :locals => {:name => :notice, :msg => 'Amount of task time is remembered'}
  end

end
