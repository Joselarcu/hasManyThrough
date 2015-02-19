class User < ActiveRecord::Base

	has_many :projects_users, dependent: :destroy
	has_many :projects, through: :projects_users
	accepts_nested_attributes_for :projects

end
