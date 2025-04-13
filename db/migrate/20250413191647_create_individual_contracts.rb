class CreateIndividualContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :individual_contracts do |t|
      t.references :contract, null: false, foreign_key: true
      t.text :service_description
      t.decimal :price
      t.string :duration

      t.timestamps
    end
  end
end
