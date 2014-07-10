module CommonValidationModule
  def email_list_check(email_list)
    if email_list.nil?
      return ""
    else
      email_ary = email_list.strip.split(%r{[,; ]+\s*}).reject{|c| c.empty?}
      regexp = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      email_ary.each do |e|
        return false unless regexp.match(e)
      end 
      return email_ary.join(' ')
    end
  end
end