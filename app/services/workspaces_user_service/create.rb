module WorkspacesUserService
  class Create < ApplicationService
    def call(workspace, current_user, role)
      @workspace = workspace

      if @workspace.save
        UserWorkspace.create!(user: current_user, workspace: @workspace, profile_name: current_user.name, profile_status: 'away', role: role)
        success(@workspace)
      else
        failure("Workspace could not be saved.")
      end
    end
  end
end
