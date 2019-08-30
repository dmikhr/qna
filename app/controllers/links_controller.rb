class LinksController < ApplicationController
  before_action :set_link, only: %i[destroy]

  authorize_resource

  def destroy
    @link.destroy if current_user&.author_of?(@link.linkable)
  end

  private

  def set_link
    @link = Link.find(link_id)
  end

  def link_id
    params.require(:id)
  end
end
