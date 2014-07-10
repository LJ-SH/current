module StatefulObjProcModule
  def status_select_collection
  	@status_collection_max_index = self.class.status_collection.size-1
    if self.new_record?
      return self.class.status_collection[0..0]
    else 
      case before_transition_state
        when self.class.status_collection[0] then self.class.status_collection[0..1] 
        when self.class.status_collection[1] then self.class.status_collection[1..2]
        when self.class.status_collection[2] then self.class.status_collection[2..3]
        when self.class.status_collection[3] then self.class.status_collection[3..4]  
        else self.class.status_collection[@status_collection_max_index..@status_collection_max_index]
      end 
    end
  end

  def display_approved_by?
    self.class.status_collection[1..4].include?(self.before_transition_state) 
  end

  def model_fixed?
    self.class.status_collection[2..4].include?(self.before_transition_state)
  end
end