class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      t.column "first_name",                :string,   :limit => 128
      t.column "last_name",                 :string,   :limit => 128
      t.column "login",                     :string
      t.column "email",                     :string
      t.column "created_at",                :datetime
      t.column "updated_at",                :datetime
      t.column "remember_token",            :string
      t.column "remember_token_expires_at", :datetime
      t.column "organization",              :string,   :limit => 36
      t.column "super_user",                :boolean
    end
  end

  def self.down
    drop_table :users
  end
end
