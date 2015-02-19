class ProjectsUser < ActiveRecord::Base
  
  self.primary_key = :id
  belongs_to :project
  belongs_to :user

  after_destroy :delete_projects

  private
	def delete_projects
		project = Project.find(self.project_id)
		if project.users.count == 0
			project.destroy
		end
	end

end
