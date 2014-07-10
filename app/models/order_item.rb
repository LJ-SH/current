class OrderItem < ActiveRecord::Base
  attr_accessible :volume, :price, :comment, :part_number_id,
                  :part_number_code, :part_number_vendor_code, :purchase_order_id
  attr_accessor :part_number_code, :part_number_vendor_code

  belongs_to :purchase_order, :inverse_of => :order_items
  belongs_to :part_number, :inverse_of => :order_items

  validates_numericality_of :volume, :only_integer => true, :message => :volume_invalid
  validates_presence_of :price, :message => :price_invalid
  validate :volume_reach_min_amount, :unless => "volume.blank?"
  validate :part_number_not_empty, :part_number_not_exist

  def part_number_not_empty
    errors.add(:part_number_code, :part_number_absence) if self.part_number_id.blank?
  end
  def part_number_not_exist
    if self.id.blank?
      errors.add(:part_number_code, :order_pn_duplicate) unless OrderItem.where(:part_number_id => self.part_number_id, :purchase_order_id => self.purchase_order_id).blank?
    else
      errors.add(:part_number_code, :order_pn_duplicate) unless OrderItem.where('id != ?', self.id).where(:part_number_id => self.part_number_id, :purchase_order_id => self.purchase_order_id).blank?
    end
  end

  def volume_reach_min_amount
    if self.volume < self.part_number.min_amount
      errors.add(:volume, :lower_than_min_amount, :amount => self.part_number.min_amount)
    end
  end

  def part_number_code
    self.part_number.code unless self.part_number.nil?
  end

  def part_number_vendor_code
    self.part_number.vendor_code unless self.part_number.nil?
  end

  def display_name
    self.part_number.name
  end 
end

  #scope :pn_code_eq, lambda {|id| includes(:part_number).where(:part_numbers => {:code => id}) unless id.nil?}  
  #scope :pn_vendor_code_eq, lambda {|id| includes(:part_number).where(:part_numbers => {:vendor_code => id}) unless id.nil?}  
  #search_methods :pn_vendor_code_eq, :pn_code_eq
  #scope :pn_code_contains, lambda {|id| includes(:part_number).where("part_numbers.code LIKE ?", "%#{id}%") unless id.nil?}  
  #scope :pn_vendor_code_contains, lambda {|id| includes(:part_number).where("part_numbers.vendor_code LIKE ?", "%#{id}%") unless id.nil?}  
  #search_methods :pn_vendor_code_contains, :pn_code_contains
