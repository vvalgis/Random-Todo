class Task < ActiveRecord::Base
  
  WAITING = 1
  IN_PROGRESS = 2
  DELAYED = 4
  DONE = 8
  
  attr_accessible :essence, :duration, :daypart, :urgency, :status
  
  belongs_to :user
  
  scope :delayed, lambda { where(:status => Task::DELAYED) }
  scope :in_progress, lambda { where(:status => Task::IN_PROGRESS).limit(1) }
  #scope :not_in_progress, lambda { where(:in_progress => false) }
  scope :has_done, where(:status => Task::DONE).order('updated_at DESC')
  scope :is_waiting, lambda { where(:status => Task::WAITING) }
  scope :urgent, lambda { where(:urgency => true) }
  scope :for_current_daypart, lambda { where(:daypart => current_daypart) }
  scope :for_any_daypart, lambda { where(:daypart => 0) }
  scope :in_time, lambda { |free_time| where(['duration <= ?', free_time]) }
  
  def Task.durations(for_select = false)
    d = {15 => 'less than 15 minutes', 60 => 'less than 1 hour', 180 => 'less than 3 hours', 360 => 'more than 3 hours'}
    for_select ? d.invert.to_a.sort : d
  end
  
  def Task.dayparts(for_select = false)
    d = { 0 => 'anytime', 1 => 'night (00:00 - 06:00)', 2 => 'morning (06:00 - 12:00)', 3 => 'day (12:00 - 18:00)', 4 => 'evening  (18:00 - 24:00)'}
    for_select ? d.invert.to_a.sort : d
  end
  
  def Task.urgencies(for_select = false)
    u = { 0 => '', 1 => 'Certainly today'}
    for_select ? u.invert.to_a : u
  end
  
  def Task.current_daypart(t = Time.now)
    case t.to_i - Time.local(t.year, t.month, t.day).to_i
      when 0..21599 then 1
      when 21600..43199 then 2
      when 43200..64799 then 3
      when 64800..86399 then 4
    end
  end
  
end
