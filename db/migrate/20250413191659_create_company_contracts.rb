class CreateCompanyContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :company_contracts do |t|
      t.references :contract, null: false, foreign_key: true
      t.string :company_name
      t.string :registration_no
      t.string :representative
      t.text :service_description
      t.decimal :price
      t.string :duration
      t.string :company_address

      t.timestamps
    end
  end
end
