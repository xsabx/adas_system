class CreateTechnicalRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :technical_requests do |t|
      t.references :request, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
