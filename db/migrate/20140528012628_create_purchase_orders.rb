class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.string   	:name
      t.string   	:order_id,                  :limit => 18
      t.references 	:supplier
      t.references 	:supply_agent
      t.references 	:oem
      t.column      :delivery_vendor, :enum, :limit => COURIER_DEFINTION
      t.string      :delivery_tracking_number
      #t.datetime  	:created_at
      t.string    	:prepared_by
      t.string    	:approved_by
      t.column  	:status, :enum, :limit => PROCUREMENT_STATUS_DEFINTION, :default => PROCUREMENT_STATUS_DEFINTION[0]      
    end
  end
end
