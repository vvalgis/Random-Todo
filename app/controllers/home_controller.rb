class HomeController < ApplicationController
  def dashboard
    @tasks_finished = Task.has_done.limit(7)
    @task = Task.in_progress.first
    unless @task
      @task = Task.urgent_for_current_daypart.rand
      unless @task
        @task = Task.urgent.rand
        unless @task
          @task = Task.for_current_daypart.rand
        end
      end
    end
  end

end
