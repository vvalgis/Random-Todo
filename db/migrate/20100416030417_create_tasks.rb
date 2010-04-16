class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :essence, :default => 'Do something weird immediately!'
      t.integer :duration, :default => 15
      t.integer :daypart, :default => 0
      t.boolean :urgency, :default => false
      t.boolean :is_done, :default => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :tasks
  end
end
