class AddCommentCountToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :comments_count, :integer
  end
end
