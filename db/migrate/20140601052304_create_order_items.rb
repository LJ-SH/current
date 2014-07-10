class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references  :part_number
      t.integer     :volume
      t.decimal 	  :price, :precision => 8, :scale => 2
      t.string  	  :comment
      t.references  :purchase_order
      #t.string   	  :orderable_type      
    end
  end
end
