class Api::V1::ProfilesController < Api::V1::BaseController

  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  def index
    profiles_except_auth = User.where.not(id: current_resource_owner.id)
    render json: profiles_except_auth
  end
end
