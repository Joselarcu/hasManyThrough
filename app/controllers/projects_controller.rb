class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :get_user, only: [:new, :create, :index, :update, :edit, :show, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = @user.projects
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.find_or_initialize_by(project_params)
    if @project.new_record?
      respond_to do |format|
        if  @project.save
          @projects_user = ProjectsUser.new(:project_id => @project.id, :user_id => @user.id)
          @projects_user.save
          format.html { redirect_to user_path(@user), notice: 'Project was successfully created.' }
          format.json { render :show, status: :created, location: @project }
        else
          format.html { render :new }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
          
      #proyect already asigned to this user, does not do anything
      if project_already_assigned?(@user, @project)
        redirect_to user_path(@user), notice: 'Project is already asigned to this user' 
      else
        #add relation between project and user
        @projects_user = ProjectsUser.new(:project_id => @project.id, :user_id => @user.id)
        @projects_user.save
        redirect_to user_path(@user), notice: "This project now has #{@project.users.length} working on it"
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to user_projects_path(@user), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to user_path(@user), notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name)
    end

    def get_user
      @user = User.find(params[:user_id])
    end

    def project_already_assigned?(user,project)
      projects = user.projects
      pa = projects.find{|p| p.id == project.id}
      not pa.nil?
    end
end
