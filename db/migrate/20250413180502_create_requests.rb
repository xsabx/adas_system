class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :request_type
      t.string :status

      t.timestamps
    end
  end
end
