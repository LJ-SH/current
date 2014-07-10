require "stateful_object_proc_module"
require "common_validation_module"
class PurchaseOrder < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :order_id, :supplier_id, :supply_agent_id, :oem_id,
  				  :delivery_vendor, :delivery_tracking_number,
  				  :prepared_by,:approved_by, :status, :order_items_attributes,
            :supply_type, :supplier_dist_list, :dest_addr, :oem_dist_list, :src_addr, :s_name, :sa_name
  attr_accessor :s_name, :sa_name

  has_many :order_items, :dependent => :destroy, :inverse_of => :purchase_order
  accepts_nested_attributes_for :order_items, :allow_destroy => true

  has_many :part_numbers, :through => :order_items
  accepts_nested_attributes_for :part_numbers, :allow_destroy => false

  belongs_to :supplier, :inverse_of => :purchase_orders
  belongs_to :supply_agent, :inverse_of => :purchase_orders
  belongs_to :oem, :inverse_of => :purchase_orders

  validates_presence_of :name
  validates_uniqueness_of :name
  validates :order_id, :format => {:with => /\A\d{8}-\d{4}-\d{4}\z/, :message => :order_item_order_id_invalid}
  validates_uniqueness_of :order_id
  validates_presence_of :supply_type

  # validate the supplier_dist_list & oem_dist_list
  #validates_presence_of :supplier_dist_list
  include CommonValidationModule
  validate :supplier_dist_list_check, :oem_dist_list_check
  def supplier_dist_list_check
    if rst = email_list_check(self.supplier_dist_list)
      self.supplier_dist_list = rst
    else
      errors.add(:supplier_dist_list, :email_not_recognize)
      return
    end
  end
  def oem_dist_list_check
    if rst = email_list_check(self.oem_dist_list)
      self.oem_dist_list = rst
    else
      errors.add(:oem_dist_list, :email_not_recognize)
      return
    end
  end

  # validate the supplier or supply_agent, and only one of them could exist
  validates_exclusion_of :supply_agent, in: [:supplier_itself, :supplier_agent]
  validate :supplier_exclusive_check
  def supplier_exclusive_check
    if self.supply_type.to_s == "supplier_itself"
      self.supply_agent_id = ""
      errors.add(:s_name, :blank) if (self.supplier_id.blank? || self.s_name.blank?)
    else 
      self.supplier_id = ""
      errors.add(:sa_name, :blank) if (self.supply_agent_id.blank? || self.sa_name.blank?)
    end
  end  

  ## start of state defintion ==========================================
  after_initialize do
    self.before_transition_state = self.status
  end

  # DEFAULT_STATUS_DEFINITION = [:status_in_progress, :status_pending_approval, :status_active, :status_transient, :status_outdated]
  @@status_collection = PROCUREMENT_STATUS_DEFINTION
  def PurchaseOrder.status_collection 
    @@status_collection 
  end

  scope  :status_before_submitted, where(:status => [:status_in_progress, :status_pending_confirmation])
  scope  :status_in_transit, where(:status => [:status_submitted, :status_in_delivery])
  scope  :status_post_received, where(:status => [:status_received, :status_closed])
  
  attr_accessible :prepared_by, :approved_by, :status, :change_histories_attributes
  attr_accessor :before_transition_state

  validates_presence_of :prepared_by
  validates_presence_of :approved_by, :unless => Proc.new{|obj| @@status_collection[0..1].include?(obj.status)}

  has_many :change_histories, :as => :trackable_obj, :dependent => :destroy, :inverse_of => :trackable_obj
  accepts_nested_attributes_for :change_histories, :allow_destroy => true 

  include StatefulObjProcModule
  ## end of state definition ==============================================

  def s_name
    self.supplier.corporate_name unless self.supplier.nil?
  end

  def s_name_include?(str)
    self.supplier.nil?? false : self.supplier.corporate_name.include?(str)
  end

  def sa_name
    self.supply_agent.corporate_name unless self.supply_agent.nil?
  end

  def sa_name_include?(str)
    self.supply_agent.nil?? false : self.supply_agent.corporate_name.include?(str)
  end

  def lock_order_item
    self.order_items.each{|item|
      item.locked_boolean = true
    }
  end

  def order_price_visible?(usr)
    usr.price_visible? or [self.prepared_by, self.approved_by].include?(usr.email)
  end

  scope :s_name_contains, lambda{|str| PurchaseOrder.where("id IN (#{PurchaseOrder.all.select{|po| po.s_name_include?(str)}.map(&:id).join(',')})")}
  scope :sa_name_contains, lambda{|str| PurchaseOrder.where("id IN (#{PurchaseOrder.all.select{|po| po.sa_name_include?(str)}.map(&:id).join(',')})")}
  scope :part_number_code_contains, lambda{|str| PurchaseOrder.joins(:part_numbers).where("part_numbers.code LIKE ?", "%#{str}%")}  
  search_methods :s_name_contains, :sa_name_contains, :part_number_code_contains

end
