class FilesController < ApplicationController

  def destroy
    @file = ActiveStorage::Attachment.find(file_id)
    @file.purge if current_user&.author_of?(@file.record)
  end

  private

  def file_id
    params.require(:id)
  end
end
