class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :login,                     :limit => 40
      t.string :email,                     :limit => 100
      t.string :crypted_password,          :limit => 40
      t.string :salt,                      :limit => 40
      t.string :remember_token,            :limit => 40
      t.datetime :remember_token_expires_at

      # Name value object poulates these fields
      t.string :title,                     :limit => 10,  :default => '', :null => true
      t.string :first_name,                :limit => 100, :default => '', :null => true
      t.string :initials,                  :limit => 10,  :default => '', :null => true
      t.string :last_name,                 :limit => 100, :default => '', :null => true
      t.string :known_as,                  :limit => 25,  :default => '', :null => true

      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
