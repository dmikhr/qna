class Api::V1::BaseController < ApplicationController

  before_action :doorkeeper_authorize!

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # http://connect.thinknetica.com/t/zanyatiya-14-i-15-razrabotka-rest-api-voprosy-i-kommentarii/482/34
  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
