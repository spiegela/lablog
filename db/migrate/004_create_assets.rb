class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table "assets" do |t|
      t.column "name",                   :string
      t.column "platform",               :string
      t.column "producer",               :string
      t.column "model",                  :string,  :limit => 64
      t.column "serial_number",          :string,  :limit => 64
      t.column "hourly_cost_in_dollars", :integer
      t.column "active",                 :boolean
      t.column "virtualized",            :boolean
      t.column "registration_key",       :text
      t.column "type",                   :string
      t.column "lab_id",                 :integer
    end
  end

  def self.down
    drop_table :assets
  end
end
