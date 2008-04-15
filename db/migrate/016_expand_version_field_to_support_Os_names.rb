class ExpandVersionFieldToSupportOsNames < ActiveRecord::Migration
  def self.up
    change_column :versions, :version, :string, :limit => 60
  end

  def self.down
    change_column :versions, :version, :string, :limit => 16
  end
end