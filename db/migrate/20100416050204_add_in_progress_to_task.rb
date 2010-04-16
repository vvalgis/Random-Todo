class AddInProgressToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :in_progress, :boolean, :default => false
  end

  def self.down
    remove_column :tasks, :in_progress
  end
end
