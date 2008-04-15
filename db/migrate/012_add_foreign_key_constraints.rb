# Add the Constraints for any existing tables
# Using Redhill foreign_key_migrations plugin
# Future Constraints will be added as fk columns
# themselves occur using the same plugin
class AddForeignKeyConstraints < ActiveRecord::Migration
  def self.up
    add_foreign_key(:grants, :lab_id, :labs, :id, :on_delete => :cascade)
    add_foreign_key(:grants, :user_id, :users, :id, :on_delete => :cascade)
    add_foreign_key(:assets, :lab_id, :labs, :id, :on_delete => :set_null)
    add_foreign_key(:hardware_dependencies, :software_id, :assets, :id,
      :on_delete => :cascade)
    add_foreign_key(:hardware_dependencies, :equipment_id, :assets, :id,
      :on_delete => :set_null)
    add_foreign_key(:versions, :asset_id, :assets, :id, :on_delete => :cascade)
    add_foreign_key(:interfaces, :asset_id, :assets, :id,
      :on_delete => :cascade)
    add_foreign_key(:designations, :asset_id, :assets, :id,
      :on_delete => :cascade)
    add_foreign_key(:designations, :user_id, :users, :id,
      :on_delete => :cascade)
    add_foreign_key(:reservations, :lab_id, :labs, :id,
      :on_delete => :set_null)
    add_foreign_key(:reservations, :user_id, :users, :id,
      :on_delete => :set_null)
    add_foreign_key(:usages, :reservation_id, :reservations, :id,
      :on_delete => :cascade)
    add_foreign_key(:usages, :asset_id, :assets, :id, :on_delete => :set_null)
    add_foreign_key(:usages, :version_id, :versions, :id,
      :on_delete => :set_null)
    add_foreign_key(:activations, :reservation_id, :reservations, :id,
      :on_delete => :restrict)
    add_foreign_key(:activations, :user_id, :users, :id,
      :on_delete => :set_null)
  end

  def self.down
    remove_foreign_key(:grants, :grants_lab_id_fkey)
    remove_foreign_key(:grants, :grants_user_id_fkey)
    remove_foreign_key(:assets, :assets_lab_id_fkey)
    remove_foreign_key(:hardware_dependencies, :hardware_dependencies_equipment_id_fkey)
    remove_foreign_key(:hardware_dependencies, :hardware_dependencies_software_id_fkey)
    remove_foreign_key(:versions, :versions_asset_id_fkey)
    remove_foreign_key(:interfaces, :interfaces_asset_id_fkey)
    remove_foreign_key(:designations, :designations_asset_id_fkey)
    remove_foreign_key(:designations, :designations_user_id_fkey)
    remove_foreign_key(:reservations, :reservations_lab_id_fkey)
    remove_foreign_key(:reservations, :reservations_user_id_fkey)
    remove_foreign_key(:usages, :usages_reservation_id_fkey)
    remove_foreign_key(:usages, :usages_asset_id_fkey)
    remove_foreign_key(:usages, :usages_version_id_fkey)
    remove_foreign_key(:activations, :activations_reservation_id_fkey)
    remove_foreign_key(:activations, :activations_user_id_fkey)
  end
end
