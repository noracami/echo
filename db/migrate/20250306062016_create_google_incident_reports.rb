class CreateGoogleIncidentReports < ActiveRecord::Migration[7.2]
  def change
    create_table :google_incident_reports do |t|
      t.json :raw
      t.string :incident_id
      t.string :summary

      t.timestamps
    end
  end
end
