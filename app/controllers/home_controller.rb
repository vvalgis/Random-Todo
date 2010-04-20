class HomeController < ApplicationController
  def dashboard
    @current_task = Task.in_progress.first
    @tasks_finished = Task.has_done.limit(7)
    @finished_count = Task.has_done.count
    @delayed_count = Task.delayed.count
  end
  
  def set_free_time
    session[:free_time] = params[:time]
    render :partial => 'shared/flash', :locals => {:name => :notice, :msg => 'Amount of your free time is remembered'}
  end

end
