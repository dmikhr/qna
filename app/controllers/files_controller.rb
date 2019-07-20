class FilesController < ApplicationController

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if current_user&.author_of?(@file.record)
  end
end
