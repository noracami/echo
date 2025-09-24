class CreateCustomReports < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_reports do |t|
      t.string :sub
      t.json :description

      t.timestamps
    end
    add_index :custom_reports, :sub
  end
end
