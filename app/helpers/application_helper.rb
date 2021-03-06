module ApplicationHelper
  def i18n_helper(model_name,attr_name)
    I18n.t("activerecord.attributes.#{model_name}.#{attr_name}")
  end	

  def i18n_status_helper(status)
    I18n.t("active_admin.scopes.#{status}")
  end  

  def i18n_model_helper(model_name)
  	I18n.t("activerecord.models.#{model_name}.one")
  end
end
