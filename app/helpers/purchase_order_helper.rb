module PurchaseOrderHelper
  def i18n_order_item_action_helper(id)
    link_to I18n.t('active_admin.actions.manage_order_items'), admin_purchase_order_order_items_path(id), :class=>"member_link"
  end
end
