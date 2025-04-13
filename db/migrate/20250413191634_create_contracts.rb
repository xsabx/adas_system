class CreateContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :contracts do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :registered_by
      t.string :status
      t.datetime :signed_at
      t.datetime :registration_time

      t.timestamps
    end
  end
end
