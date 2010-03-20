# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100225121140) do

  create_table "allocation_round", :id => false, :force => true do |t|
    t.integer  "round",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disciplines", :force => true do |t|
    t.string "name"
    t.string "long_name"
  end

  create_table "disciplines_projects", :id => false, :force => true do |t|
    t.integer "discipline_id"
    t.integer "project_id"
  end

  add_index "disciplines_projects", ["discipline_id"], :name => "index_disciplines_projects_on_discipline_id"
  add_index "disciplines_projects", ["project_id"], :name => "index_disciplines_projects_on_project_id"

  create_table "four_oh_fours", :force => true do |t|
    t.string   "url"
    t.string   "referer"
    t.integer  "count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "four_oh_fours", ["url", "referer"], :name => "index_four_oh_fours_on_url_and_referer", :unique => true
  add_index "four_oh_fours", ["url"], :name => "index_four_oh_fours_on_url"

  create_table "news_items", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_allocations", :force => true do |t|
    t.integer  "student_id",       :null => false
    t.integer  "project_id",       :null => false
    t.integer  "supervisor_id",    :null => false
    t.integer  "allocation_round", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_allocations", ["allocation_round"], :name => "index_project_allocations_on_allocation_round"
  add_index "project_allocations", ["project_id"], :name => "index_project_allocations_on_project_id"
  add_index "project_allocations", ["student_id"], :name => "index_project_allocations_on_student_id"
  add_index "project_allocations", ["supervisor_id"], :name => "index_project_allocations_on_supervisor_id"

  create_table "project_selections", :force => true do |t|
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round",      :default => 1
  end

  create_table "projects", :force => true do |t|
    t.integer  "created_by"
    t.string   "title"
    t.text     "description"
    t.text     "resources"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "carbon_critical", :default => false
    t.boolean  "sure",            :default => false
    t.boolean  "allocated",       :default => false
    t.boolean  "available",       :default => true
  end

  add_index "projects", ["created_by"], :name => "index_projects_on_created_by"

  create_table "projects_supervisors", :id => false, :force => true do |t|
    t.integer "supervisor_id"
    t.integer "project_id"
  end

  add_index "projects_supervisors", ["project_id"], :name => "index_projects_supervisors_on_project_id"
  add_index "projects_supervisors", ["supervisor_id"], :name => "index_projects_supervisors_on_supervisor_id"

  create_table "research_centres", :force => true do |t|
    t.string   "abbrev",      :limit => 10
    t.string   "title"
    t.integer  "coordinator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "selected_projects", :force => true do |t|
    t.integer "project_selection_id"
    t.integer "position"
    t.integer "project_id"
  end

  create_table "status_settings", :force => true do |t|
    t.integer  "code"
    t.string   "title"
    t.text     "message"
    t.integer  "permissions",     :default => 28672
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "can_select",      :default => false
    t.boolean  "can_allocate",    :default => false
    t.integer  "selection_round", :default => 0
  end

  create_table "statuses", :force => true do |t|
    t.integer  "status_setting_id", :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "grade"
    t.integer  "discipline_id"
    t.string   "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "board_decision"
  end

  add_index "students", ["student_id"], :name => "index_students_on_student_id", :unique => true

  create_table "supervisors", :force => true do |t|
    t.integer  "research_centre_id"
    t.integer  "user_id"
    t.string   "staff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loading",            :default => 4
    t.integer  "load",               :default => 0
  end

  add_index "supervisors", ["staff_id"], :name => "index_supervisors_on_staff_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "first_name",                :limit => 100, :default => ""
    t.string   "last_name",                 :limit => 100, :default => ""
    t.string   "title",                     :limit => 10,  :default => ""
    t.string   "initials",                  :limit => 10,  :default => ""
    t.string   "known_as",                  :limit => 25,  :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
