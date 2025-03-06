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
    gir = if echo_params[:incident].present?
      GoogleIncidentReport.create(
        raw: echo_params,
        incident_id: echo_params.dig(:incident, :incident_id),
        summary: echo_params.dig(:incident, :summary),
      )
    elsif echo_params[:subject].present?
      GoogleIncidentReport.create(
        raw: echo_params,
        incident_id: Time.now.to_i,
        summary: echo_params[:subject],
      )
    else
      GoogleIncidentReport.create(
        raw: echo_params,
        incident_id: Time.now.to_i,
        summary: "No summary provided",
      )
    end

    # use Faraday to post to Discord
    webhook_url = Rails.application.credentials.discord.webhook_url

    connection = Faraday.new webhook_url
    connection.post do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = {
        content: "New incident report: #{gir.summary}\n#{ENV["APP_URL"]}/r/#{gir.incident_id}",
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
    params.require(:echo).permit!
  end
end
