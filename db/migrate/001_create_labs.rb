class CreateLabs < ActiveRecord::Migration
  def self.up
    create_table "labs" do |t|
      t.column "name",       :string,  :limit => 32
      t.column "short_name", :string,  :limit => 16
      t.column "location",   :string
      t.column "district",   :integer
      t.column "region",     :integer
      t.column "division",   :string,  :limit => 32
      t.column "firewall",   :string,  :limit => 32
    end    
  end

  def self.down
    drop_table :labs
  end
end
