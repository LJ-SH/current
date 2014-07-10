class AddAddrAndSupplyTypeToPurchaseOrder < ActiveRecord::Migration
  def change
  	add_column :purchase_orders, :supply_type, :enum, :limit => [:supplier_itself, :supplier_agent], :default => :supplier_itself
  	add_column :purchase_orders, :src_addr, :string
  	add_column  :purchase_orders, :supplier_dist_list, :string
  	add_column :purchase_orders, :dest_addr, :string
  	add_column  :purchase_orders, :oem_dist_list, :string  	  	
  end
end
