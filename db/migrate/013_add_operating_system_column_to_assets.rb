class AddOperatingSystemColumnToAssets < ActiveRecord::Migration
  def self.up
    add_column(:assets, :operating_system, :string)
  end

  def self.down
    remove_column(:assets, :operating_system)
  end
end