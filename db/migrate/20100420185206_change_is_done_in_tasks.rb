class ChangeIsDoneInTasks < ActiveRecord::Migration
  def self.up
    change_column :tasks, :is_done, :integer, :default => 1
    rename_column :tasks, :is_done, :status
    remove_column :tasks, :in_progress
  end

  def self.down
    rename_column :tasks, :status, :is_done
    change_column :tasks, :is_done, :boolean, :default => false
    add_column :tasks, :in_progress, :boolean, :default => false
  end
end
