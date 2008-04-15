class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table "versions" do |t|
      t.column "version",                   :string,  :limit => 16
      t.column "asset_id",                  :integer
      t.column "currently_at_this_version", :boolean
    end
  end

  def self.down
    drop_table :versions
  end
end
