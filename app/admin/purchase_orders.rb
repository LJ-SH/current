ActiveAdmin.register PurchaseOrder do
  menu :parent => 'menu_rnd'
  config.batch_actions = false
  scope_to :current_user, unless: proc{ current_user.admin? }   

  scope  :all, :default => true
  scope  :status_before_submitted
  scope  :status_in_transit
  scope  :status_post_received  

  filter :order_id
  filter :name
  filter :s_name, :as => :string
  filter :sa_name, :as => :string
  filter :part_number_code, :as => :string

  index do 
    column :name
    column :order_id
    column :prepared_by
    column :approved_by    
    #column :status, :class => 'set_min_column_width' do |bom|
    #  status_tag(I18n.t("active_admin.scopes.#{bom.status}"))
    #end
    actions :defaults => true do |resource|
      link = i18n_order_item_action_helper(resource.id)
    end     
  end

  form do |f|
    render :partial => "form"    
  end

  action_item :only => [:edit, :show] do
    #link_to I18n.t('active_admin.actions.manage_order_items'), admin_purchase_order_order_items_path(resource)
    i18n_order_item_action_helper(resource.id)
  end

  # here is the part for show action, seperated into 2 column. comment-by-LJ on 2-May-2013
  show do |po|
    attributes_table do
      rows :name, :order_id
      row  :status do
        I18n.t("active_admin.scopes.#{po.status}")
      end
      #if current_admin_user.admin?
      #  row  :latest_price
      #end
      rows :supplier_id, :supply_agent_id, :oem_id       
      rows :delivery_vendor, :delivery_tracking_number
      rows :prepared_by, :approved_by
    end

    panel 'order item' do 
      table_for po.order_items, i18n: OrderItem do
        column :part_number_code
        column :part_number_vendor_code
        column :volume
        column :price if current_admin_user.price_visible?
    	  column :comment
      end
    end

    panel t 'formtastic.titles.change_history' do 
      table_for po.change_histories, i18n: ChangeHistory do
        column :notes
        column :updated_by
        column :updated_at
      end
    end
  end  

  controller do
    before_filter :supply_name_check, :only => [:create, :update]

    def supply_name_check
      #logger.info params[:purchase_order]
      unless params[:purchase_order].nil? then
        params[:purchase_order][:supply_type].eql?("supplier_agent")? params[:purchase_order][:supplier_id] = "" : params[:purchase_order][:supply_agent_id] = ""
      end
    end
  end
end
