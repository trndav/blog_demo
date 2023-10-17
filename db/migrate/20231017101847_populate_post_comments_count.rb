class PopulatePostCommentsCount < ActiveRecord::Migration[7.0]
  def change
    Post.all.each do |post|
      
      # reset_counters Rails method used to reset counter caches
      Post.reset_counters(post.id, :comments)

      # add/update :comment_count to post.comment.count
      # ?? post.update_column(:comments_count, post.comments.count)
    end
  end
end
