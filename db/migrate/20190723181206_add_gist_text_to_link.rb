class AddGistTextToLink < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :gist_text, :string
  end
end
