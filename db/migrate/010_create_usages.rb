class CreateUsages < ActiveRecord::Migration
  def self.up
    create_table "usages" do |t|
      t.column "destructive",         :boolean
      t.column "exclusive",           :boolean
      t.column "reservation_id",      :integer
      t.column "asset_id",            :integer
      t.column "version_id",          :integer
      t.column "asset_type",          :string,  :limit => 30
      t.column "optional",            :boolean
      t.column "as_prerequisite_for", :integer
    end
  end

  def self.down
    drop_table :usages
  end
end
