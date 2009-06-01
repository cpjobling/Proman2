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

ActiveRecord::Schema.define(:version => 20090601155225) do

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

  create_table "project_allocations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_selections", :force => true do |t|
    t.integer  "project_id"
    t.integer  "student_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "projects_supervisors", :id => false, :force => true do |t|
    t.integer "supervisor_id"
    t.integer "project_id"
  end

  add_index "projects_supervisors", ["project_id"], :name => "index_projects_supervisors_on_project_id"
  add_index "projects_supervisors", ["supervisor_id"], :name => "index_projects_supervisors_on_supervisor_id"

  create_table "research_centres", :force => true do |t|
    t.string   "abbrev"
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

  create_table "students", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "grade",                 :precision => 10, :scale => 2
    t.integer  "project_selection_id"
    t.integer  "project_allocation_id"
    t.integer  "discipline_id"
    t.string   "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["student_id"], :name => "index_students_on_student_id", :unique => true

  create_table "supervisors", :force => true do |t|
    t.integer  "research_centre_id"
    t.integer  "user_id"
    t.string   "staff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
