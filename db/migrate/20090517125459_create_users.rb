class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime

      # Name value object poulates these fields
      t.column :title,                     :string, :limit => 10,  :default => '', :null => true
      t.column :first_name,                :string, :limit => 100, :default => '', :null => true
      t.column :initials,                  :string, :limit => 10,  :default => '', :null => true
      t.column :last_name,                 :string, :limit => 100, :default => '', :null => true
      t.column :known_as,                  :string, :limit => 25,  :default => '', :null => true

    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
