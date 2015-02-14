class AddPrimaryKeyToUsersProjectsTable < ActiveRecord::Migration
  def change
  	add_column :projects_users, :id, :primary_key
  end
end
