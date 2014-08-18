class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.timestamps

      t.string  :zone, null: false
      t.text    :body, null: false
    end
  end
end
