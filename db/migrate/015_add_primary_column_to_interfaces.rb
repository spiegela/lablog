class AddPrimaryColumnToInterfaces < ActiveRecord::Migration
  def self.up
    add_column(:interfaces, :primary, :boolean)
  end

  def self.down
    remove_column(:interfaces, :primary)
  end
end