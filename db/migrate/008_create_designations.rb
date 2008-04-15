class CreateDesignations < ActiveRecord::Migration
  def self.up
    create_table "designations" do |t|
      t.column "primary_contact", :boolean
      t.column "asset_id",        :integer, :null => false
      t.column "user_id",         :integer, :null => false
    end
  end

  def self.down
    drop_table :designations
  end
end
