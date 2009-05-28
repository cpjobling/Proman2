class CreateDisciplines < ActiveRecord::Migration
  def self.up
    create_table "disciplines" do |t|
      t.column :name, :string
      t.column :long_name, :string
    end
    
    
    # generate the join table
    create_table "disciplines_projects", :id => false do |t|
      t.column "discipline_id", :integer
      t.column "project_id", :integer
    end
    add_index "disciplines_projects", "discipline_id"
    add_index "disciplines_projects", "project_id"
  end

  def self.down
    drop_table "disciplines"
    drop_table "disciplines_projects"
  end
end
