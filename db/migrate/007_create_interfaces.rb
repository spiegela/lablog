class CreateInterfaces < ActiveRecord::Migration
  def self.up
    create_table "interfaces" do |t|
      t.column "name",       :string,  :limit => 32
      t.column "ip_address", :string,  :limit => 32
      t.column "hostname",   :string,  :limit => 32
      t.column "asset_id",   :integer
    end    
  end

  def self.down
    drop_table :interfaces
  end
end
