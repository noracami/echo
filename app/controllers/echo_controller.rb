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

    # use Faraday to post to Discord
    webhook_url = Rails.application.credentials.discord.webhook_url

    connection = Faraday.new webhook_url
    connection.post do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = {
        content: "New incident report: #{echo_params[:incident][:summary]}\n#{ENV["APP_URL"]}/r/#{echo_params[:incident][:incident_id]}",
        username: "Google Cloud Platform",
        avatar_url: "https://www.gstatic.com/images/branding/product/1x/cloud_64dp.png"
      }.to_json
    end

    head :ok
  end

  def show
    report = GoogleIncidentReport.find_by(incident_id: params[:incident_id])

    render json: report
  end

  private

  def echo_params
    params.require(:echo).permit(:version, incident: {})
  end
end
