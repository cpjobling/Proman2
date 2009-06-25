# Copyright 2009 Swansea University
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


ActionController::Routing::Routes.draw do |map|
  map.resources :project_allocations

  # Restful routes
  map.resources :project_selections, :except => [:show, :create], :has_many => :selected_projects

  map.resources :project_allocations, :collection => { :selections => :get, :updates => :post }

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

    map.connect 'specials',
      :conditions => { :method => :get },
      :action => "specials",
      :controller => 'projects'

  map.with_options :controller => "help" do |help|
    help.project_selection_help 'help/project_selections',
      :conditions => { :method => :get }, :action => 'project_selection'
  end

  map.resources :projects, :only => [:index, :show]

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.resources :users

  map.resource :session
  
  map.admin 'admin', :conditions => { :method => :get }, :controller => 'admin', :action => 'index'
  
  # Setup controller
  map.admin_setup 'admin/setup', :controller => 'admin/setup', :conditions => { :method => :get }, :action => 'index'
  
  map.with_options :controller => "admin/setup" do |setup|
  	setup.import_staff 'admin/setup/import_staff',
      :conditions => { :method => :get }, :action => 'import_staff'
  	setup.csv_import_staff 'admin/setup/csv_import_staff',
      :conditions => { :method => :post }, :action => "csv_import_staff"
  	setup.import_students 'admin/setup/import_students',
      :conditions => { :method => :get }, :action => 'import_students'
  	setup.csv_import_students 'admin/setup/csv_import_students',
      :conditions => { :method => :post }, :action => "csv_import_students"
    setup.import_projects 'admin/setup/import_projects',
      :conditions => { :method => :get }, :action => 'import_projects'
  	setup.csv_import_projects 'admin/setup/csv_import_projects',
      :conditions => { :method => :post }, :action => "csv_import_projects"
    setup.import_student_grades 'admin/setup/import_student_grades',
      :conditions => { :method => :get }, :action => "import_student_grades"
   	setup.csv_import_grades 'admin/setup/csv_import_grades',
      :conditions => { :method => :post }, :action => "csv_import_grades"
  end

  map.with_options :controller => "admin/projects" do |ap|
    ap.by_supervisor 'admin/projects/by_supervisor',
      :conditions => { :method => :get }, :action => "by_supervisor"
    ap.by_discipline 'admin/projects/by_discipline',
      :conditions => { :method => :get }, :action => "by_discipline"
    ap.by_centre 'ap/projects/by_centre',
      :conditions => { :method => :get }, :action => "by_centre"
  end
  
  map.coordinate 'coordinate', :conditions => { :method => :get },
    :controller => 'coordinator', :action => 'index'
  

  map.namespace :user do |user|
    #user.resources :activations
    #user.resources :invitations
    #user.resources :openid_accounts
    user.resources :passwords
    user.resources :accounts do |accounts|
      accounts.resources :password_settings
    end
    user.resources :projects
  end

  map.my_account 'my_account', :conditions => { :method => :get },
    :controller => 'user', :action => 'index'



  map.about 'about', :conditions => { :method => :get}, :controller => 'about', :action => 'index'

  map.home 'main', :conditions => { :method => :get}, :controller => 'main', :action => 'index'

  map.contact 'contact', :conditions => { :method => :get}, :controller => 'contact', :action => 'index'
  

  
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
    admin.resources :supervisors
    admin.resources :projects
    admin.resources :status_settings
    admin.resources :statuses
  end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "main"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
  map.connect '*path' , :controller => 'four_oh_fours'
end
