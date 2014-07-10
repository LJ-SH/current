class ChangeRoleDefintionInAdminUser < ActiveRecord::Migration
  def change
  	change_column :admin_users, :role, :enum, :limit => NEW_ROLE_DEFINITION, :default => :role_others  	
  end
end