class Task < ActiveRecord::Base
  attr_accessible :essence, :duration, :daypart, :urgency, :is_done, :in_progress
  
  scope :in_progress, where(:in_progress => true)
  scope :has_done, where(:is_done => true).order('updated_at DESC')
  scope :is_waiting, lambda { where(:is_done => false, :in_progress => false).order('updated_at DESC') }
  scope :urgent, lambda { where(:urgency => true, :is_done => false, :in_progress => false) }
  scope :urgent_for_current_daypart, lambda { urgent.where(:daypart => current_daypart) }
  scope :for_current_daypart, lambda { is_waiting.where(:daypart => current_daypart) }
  
  def Task.durations(for_select = false)
    d = { 0 => 'more than 3 hours', 15 => 'less than 15 minutes', 60 => 'less than 1 hour', 180 => 'less than 1 hours'}
    for_select ? d.invert.to_a : d
  end
  
  def Task.dayparts(for_select = false)
    d = { 0 => :night, 1 => :morning, 2 => :day, 3 => :evening}
    for_select ? d.invert.to_a : d
  end
  
  def Task.urgencies(for_select = false)
    u = { 0 => 'Not certainly today', 1 => 'Certainly today'}
    for_select ? u.invert.to_a : u
  end
  
  def Task.current_daypart(t = Time.now)
    case t.to_i - Time.local(t.year, t.month, t.day).to_i
      when 0..21599 then 0
      when 21600..43199 then 1
      when 43200..64799 then 2
      when 64800..86399 then 3
    end
  end
  
end
