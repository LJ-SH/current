class BomPart < ActiveRecord::Base
  attr_accessible :id, :amount, :location, :comments, :bom_id, :part_number_id

  belongs_to :bom, :inverse_of => :bom_parts
  belongs_to :part_number, :inverse_of => :bom_parts

  before_validation :pre_validation_proc
  validates_numericality_of :amount, :greater_than_or_equal_to => 1, :only_integer => true
  validates_presence_of :location
  validates_presence_of :part_number_id, :message => :part_number_absence
  validates_uniqueness_of :part_number_id, :scope => :bom_id, :message => :part_number_duplicate
  validate :part_number_location_check

  def pre_validation_proc
    # standarize the format of part_number location (reference)
    self.location = self.location.strip.split(%r{[,; ]+\s*}).reject{|c| c.empty?}.each{|x| x.capitalize!}.join(",")
  end

  def part_number_location_check
    if self.location.split(",").size != self.amount
  	  errors.add(:amount, :bom_part_location_mismatch)
  	  return
  	end 

  	bom = Bom.find(self.bom_id)
  	unless bom.nil?
  	  regExp = self.location.split(",").join(",|")
      bom.bom_parts.each do |pn|
	      if (loc = /#{regExp}/.match(pn.location+",")) && (pn.id != self.id)
	  	    errors.add(:location, :bom_part_location_duplicated, :location => loc.to_s.chomp(','))
	  	    break
	      end
  	  end 
  	else 
  	  errors.add(:error, :system_critical_exceptions)
  	end
  end

  def part_number_code
    self.part_number.code
  end

  def display_name
  	self.part_number.name
  end
end
