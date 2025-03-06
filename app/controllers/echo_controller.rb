class EchoController < ApplicationController
  skip_forgery_protection only: [ :create ]

  def ok
    render json: { message: "ok", "your ip": request.remote_ip }
  end

  def index
    reports = GoogleIncidentReport.all

    render json: reports
  end

  def create
    GoogleIncidentReport.create(
      raw: echo_params,
      incident_id: echo_params[:incident][:incident_id],
      summary: echo_params[:incident][:summary]
    )

    head :ok
  end

  private

  def echo_params
    params.require(:echo).permit(:version, incident: {})
  end
end
