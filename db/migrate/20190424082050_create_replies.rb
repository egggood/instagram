class CreateReplies < ActiveRecord::Migration[5.2]
  def change
    create_table :replies do |t|
      t.integer :micropost_id
      t.string :content

      t.timestamps
    end
  end
end
