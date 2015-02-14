class Project < ActiveRecord::Base

	has_many :projects_users, dependent: :destroy
	has_many :users, through: :projects_users

end
