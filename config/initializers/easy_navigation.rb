# TODO: create navigation
EasyNavigation::Builder.config do |map|
    map.navigation :default do |navigation|
      navigation.tab :home, :url => { :controller => "/dashboard", :action => "index"} do |tab|
        tab.menu :index, :url => { :controller => "/dashboard", :action => "index" } do |menu|
          menu.connect :controller => "dashboard"
        end
      end
      navigation.tab :contacts, :url => { :controller => "/contacts", :action => "index" } do |tab|
        tab.menu :index, :url => { :controller => "/contacts", :action => "index" } do |menu|
          menu.connect :controller => "/contacts"
          menu.connect :controller => "/contacts/people", :except => "new"
          menu.connect :controller => "/contacts/companies", :except => "new"
        end
        tab.menu :new_person, :url => { :controller => "/contacts/people", :action => "new" } do |menu|
          menu.connect :only => "new"
        end
        tab.menu :new_company, :url => { :controller => "/contacts/companies", :action => "new" } do |menu|
          menu.connect :only => "new"
        end
      end
      navigation.tab :admin, :url => { :controller => "/admin/users", :action => "index" } do |tab|
        tab.menu :index, :url => { :controller => "/admin/users", :action => "index" } do |menu|
          menu.connect :except => "new"
        end
        tab.menu :new, :url => { :controller => "/admin/users", :action => "new" } do |menu|
          menu.connect :only => "new"
        end
      end
    end
  end