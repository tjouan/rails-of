class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.timestamps
      t.references  :source,    null: false, index: true
      t.string      :sha256
      t.string      :charset,   null: false
      t.boolean     :header,    null: false, default: true
      t.string      :separator, null: false
      t.string      :file_name, null: false
    end
  end
end
