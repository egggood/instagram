class AddSelfIntroductionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :self_introduction, :string
  end
end
