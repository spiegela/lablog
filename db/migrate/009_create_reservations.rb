class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table "reservations" do |t|
      t.column "name",               :string
      t.column "start_time",         :datetime
      t.column "end_time",           :datetime
      t.column "reason",             :string
      t.column "comment",            :text
      t.column "approved_at",        :datetime
      t.column "user_id",            :integer
      t.column "approval_code",      :string
      t.column "approval_status",    :string,   :limit => 32
      t.column "approvers_comments", :string
      t.column "lab_id",             :integer
      t.column "event",              :string
    end
  end

  def self.down
    drop_table :reservations
  end
end
