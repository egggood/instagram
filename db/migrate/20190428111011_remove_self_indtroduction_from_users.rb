class RemoveSelfIndtroductionFromUsers < ActiveRecord::Migration[5.2]
  #usersテーブルにself_introductionカラムを作成しようとしたらself_indroductionを作成した
  #と勘違いしていた。それを消そうとこのmigarationfileを作成した。無駄fileなので消したい。
  def change
    remove_column :users, :self_indtroduction, :string
  end
end
