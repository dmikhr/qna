class AddNullConstraintsToAuthorizations < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:authorizations, :provider, false)
    change_column_null(:authorizations, :uid, false)
  end
end
