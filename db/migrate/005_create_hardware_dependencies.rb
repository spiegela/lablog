class CreateHardwareDependencies < ActiveRecord::Migration
  def self.up
    create_table "hardware_dependencies" do |t|
      t.column "optional",     :boolean
      t.column "exclusive",    :boolean
      t.column "destructive",  :boolean
      t.column "software_id",  :integer
      t.column "equipment_id", :integer
    end
  end

  def self.down
    drop_table :hardware_dependencies
  end
end
