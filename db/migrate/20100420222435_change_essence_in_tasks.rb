class ChangeEssenceInTasks < ActiveRecord::Migration
  def self.up
    change_column :tasks, :essence, :string, :default => 'Do something immediately!'
  end

  def self.down
    change_column :tasks, :essence, :string, :default => 'Do something weird immediately!'
  end
end
