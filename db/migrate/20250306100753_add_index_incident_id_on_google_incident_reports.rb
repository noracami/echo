class AddIndexIncidentIdOnGoogleIncidentReports < ActiveRecord::Migration[7.2]
  def change
    add_index :google_incident_reports, :incident_id
  end
end
