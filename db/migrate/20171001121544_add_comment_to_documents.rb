class AddCommentToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_reference :documents, :comment, foreign_key: true
  end
end
