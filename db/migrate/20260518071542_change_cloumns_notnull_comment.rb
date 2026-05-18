class ChangeCloumnsNotnullComment < ActiveRecord::Migration[8.0]
  def change
    change_column :comments, :content, :text, null: false
  end
end
