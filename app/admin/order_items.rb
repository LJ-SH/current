ActiveAdmin.register OrderItem do
  config.batch_actions = false
  #config.clear_sidebar_sections!
  config.comments = false
  belongs_to :purchase_order  
  #actions  :all, :except => :show  
  scope_to :current_user, unless: proc{ current_user.admin? }  

  index do
    column :part_number
    column :part_number_code, :sortable => 'part_numbers.code'
    column :part_number_vendor_code, :sortable => 'part_numbers.vendor_code'
    column :volume    
    column :price if PurchaseOrder.find(params[:purchase_order_id]).order_price_visible?(current_admin_user)
    column :comment
    actions      
  end

  sidebar :parent_purchase_order_info, :only => :index, :priority => 0 do
    attributes_table_for purchase_order do
      row :status do i18n_status_helper(purchase_order.status) end    
      row :supplier_id unless purchase_order.supplier.nil?
      row :supply_agent_id unless purchase_order.supply_agent.nil?
      row :oem      
    end 
  end 

  filter :part_number, :collection => proc {PurchaseOrder.find(params[:purchase_order_id]).part_numbers}
  filter :part_number_code, :as => :string
  filter :part_number_vendor_code, :as => :string

  form do |f|
    render :partial => "form"
  end  

  sidebar :part_number_filter, :only => [:new,:create, :edit, :update] do
    # if part_number is selected, then we shall set params[:q] appropriately
    unless order_item.part_number.nil?
      params.merge!(:q => {})
      order_item.part_number.component_category.path_ids.each_with_index {|id, i|
        params[:q].merge!(:"component_category_level#{i}_eq" => id)
      }
    end
    @search = PartNumber.search(params[:q])
    render :partial => '/admin/share/part_number_search_form', :locals => {:search => @search}
  end  

  controller do
    def scoped_collection
      super.includes(:part_number)
    end
  end
end

  #filter :pn_vendor_code, :as => :select, :collection => proc {PurchaseOrder.find(params[:purchase_order_id]).part_numbers.map(&:vendor_code)}
  #filter :pn_code, :as => :select, :collection => proc {PurchaseOrder.find(params[:purchase_order_id]).part_numbers.map(&:code)}
  #filter :volume