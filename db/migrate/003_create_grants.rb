class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table "grants" do |t|
      t.column "approver",            :boolean, :default => true
      t.column "administrator",       :boolean, :default => true
      t.column "super_administrator", :boolean, :default => false
      t.column "lab_id",              :integer, :null => false
      t.column "user_id",             :integer, :null => false
    end
  end

  def self.down
    drop_table :grants
  end
end
