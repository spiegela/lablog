class CreateActivations < ActiveRecord::Migration
  def self.up
    create_table "activations" do |t|
      t.column "ip_address",         :string,   :limit => 30
      t.column "created_at",         :datetime
      t.column "updated_at",         :datetime
      t.column "completed_at",       :datetime
      t.column "reservation_id",      :integer
      t.column "user_id",            :integer
    end
  end

  def self.down
    drop_table :activations
  end
end
