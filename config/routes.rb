ActionController::Routing::Routes.draw do |map|


 

  map.connect 'projects/by_supervisor',
    :conditions => { :method => :get },
    :controller => "projects",
    :action => "by_supervisor"

  map.connect 'projects/by_discipline',
    :conditions => { :method => :get },
    :controller => "projects",
    :action => "by_discipline"

  map.connect 'projects/by_centre',
    :conditions => { :method => :get },
    :controller => "projects",
    :action => "by_centre"

  map.connect 'my_projects',
    :conditions => { :method => :get },
    :controller => "projects",
    :action => "my_projects"

  map.resources :projects

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.resources :users

  map.resource :session
  
  map.admin 'admin', :conditions => { :method => :get }, :controller => 'admin', :action => 'index'
  
  map.with_options :controller => "admin/bulk_uploader" do |abu|
  	abu.import_staff 'admin/bulk_uploader/import_staff', 
  			:conditions => { :method => :get }, :action => 'import_staff'
  	abu.csv_import_staff 'admin/bulk_uploader/csv_import_staff', 
  			:conditions => { :method => :post }, :action => "csv_import_staff"
  	abu.import_students 'admin/bulk_uploader/import_students',
  			:conditions => { :method => :get }, :action => 'import_students'
  	abu.csv_import_students 'admin/bulk_uploader/csv_import_students',
  			:conditions => { :method => :post }, :action => "csv_import_students"
  end
     
  map.with_options :controller => "admin/projects" do |ap|
    ap.by_supervisor 'admin/projects/by_supervisor',
      :conditions => { :method => :get }, :action => "by_supervisor"
    ap.by_discipline 'admin/projects/by_discipline',
      :conditions => { :method => :get }, :action => "by_discipline"
    ap.by_centre 'ap/projects/by_centre',
      :conditions => { :method => :get }, :action => "by_centre"
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  map.namespace :admin do |admin|
        # Directs /admin/users/* to Admin::UsersController (app/controllers/admin/users_controller.rb)
        admin.resources :users
        admin.resources :students
        admin.resources :projects
   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
