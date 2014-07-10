ActiveAdmin.register Supplier do
  menu :parent => 'menu_procurement'  
  config.batch_actions = false
  config.clear_sidebar_sections!

  scope :company_active, :default => true
  scope :company_outdated
  scope :company_transient

  collection_action :autocomplete_supplier_name, :method => :get

  # here is the portion for index, comment-by-LJ on 2-May-2013
  index do |s|
    column t 'table.corporate.company_name' do |s|
      unless s.company_profile.company_name.nil? then
        link_to "#{s.company_profile.company_name}", :action => :show, :id => s.id
      end
    end
    column t 'table.corporate.company_desc' do |s|
      s.company_profile.company_desc 
    end     
    column t 'table.corporate.contact' do |s|
      s.company_profile.contact unless s.company_profile.contact.nil?
    end       
    column t 'table.corporate.sign_in_info' do |s|
      s.users.collect(&:email).join(',')
    end
    actions :defaults => false do |resource|
      link = link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class=>"member_link edit_link"
      link += link_to I18n.t('active_admin.delete'), resource_path(resource),:method => :delete, :clas=>"member_link delete_link", :confirm => I18n.t('active_admin.delete_confirmation')
      link
    end
  end

  # customize filter panel, comment-by-LJ on 2-May-2013
  sidebar :filters, :only => :index do
    render :partial => '/admin/corporate/search', :locals=>{:corporate_collection => Supplier.all}
  end


  # here is the new/edit form part, comment-by-LJ on 2-May-2013
  form do |f|
    render :partial => "/admin/corporate/form", :locals=>{:corporate => f.object}
  end

  # here is the part for show action, seperated into 2 column. comment-by-LJ on 2-May-2013
  show do |s|
    panel t 'formtastic.titles.company_profile' do
      attributes_table_for s.company_profile do 
        rows  :company_name,:company_addr, :postcode, :company_desc, :contact, :primary_phone, :secondary_phone,
              :distribution_list
        row   :appendix do
          unless s.company_profile.appendix.blank? then
            link_to "#{s.company_profile.appendix_name}", "#{s.company_profile.appendix.url}" 
          end
        end 
      end
    end

    panel t 'formtastic.titles.company_sign_in_info' do 
      table_for s.users do 
        column t('table.corporate.email') do |u| u.email end
      end
    end
  end

  sidebar :corporate_basic_info, :only => [:show] do
    attributes_table_for supplier do
      row :name
      row :comment
    end
    button_to t("link.corporate.back_to_suppliers_index"), {:action => :index}, :method => "get"
    #link_to "back_to_suppliers_index", admin_suppliers_path
  end

  # here are the controller portion, comment-by-LJ on 2-May-2013
  controller do
    autocomplete :supplier, :name, :full => true, :limit => 5

    def autocomplete_supplier_name
      logger.info 'it is invoked'
      term = params[:term]
      suppliers = Supplier.joins(:company_profile).where('company_profiles.company_name LIKE ?', "%#{term}%").order(:name).limit(5)
      render :json => suppliers.map { |supplier| {:id => supplier.id, :label => supplier.company_profile.company_name,
                                       :value => supplier.company_profile.company_name, :addr => supplier.company_profile.company_addr,
                                       :dist_list => supplier.company_profile.distribution_list} }
    end      

    def new
      @supplier = Supplier.new
      @supplier.users.build
      #@supplier.build_company_profile
      new!
    end
  end
end
