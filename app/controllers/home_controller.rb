class HomeController < ApplicationController
  def dashboard
    @tasks_finished = Task.has_done.limit(7)
    @finished_count = Task.has_done.count
    @in_progress_count = Task.is_waiting.in_progress.count
  end
  
  def set_free_time
    session[:free_time] = params[:time]
    render :partial => 'shared/flash', :locals => {:name => :notice, :msg => 'Amount of your free time is remembered'}
  end

end
