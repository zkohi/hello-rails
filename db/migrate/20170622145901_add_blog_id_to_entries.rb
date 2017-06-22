class AddBlogIdToEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :blog_id, :integer
  end
end
