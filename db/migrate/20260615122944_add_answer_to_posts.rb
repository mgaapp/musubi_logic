class AddAnswerToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :answer, :text
  end
end
