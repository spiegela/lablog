class AddReservationMembers < ActiveRecord::Migration
  def self.up
    create_table :resevations_members, :id => false do |t|
      t.column :reservation_id, :integer, :null => false,
	:references => :reservations, :on_delete => :cascade
      t.column :member_id, :integer, :null => false, :references => :users,
	:on_delete => :cascade
    end
  end

  def self.down
    drop_table :reservations_members
  end
end
