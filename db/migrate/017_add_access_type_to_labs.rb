class AddAccessTypeToLabs < ActiveRecord::Migration
  def self.up
    add_column :labs, :access_type, :string, :limit => 60
  end

  def self.down
    drop_column :labs, :access_type
  end
end