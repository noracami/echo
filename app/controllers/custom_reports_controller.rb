class CustomReportsController < ApplicationController
  skip_forgery_protection only: [ :create ]

  def index
    render json: CustomReport.last(10)
  end

  def create
    sub = params.dig("sub") || "none"
    description = params.dig("description") || "empty"

    record = CustomReport.new(sub:, description:)

    if record.save
      respond_to do |format|
        format.html { redirect_to(custom_reports_url) }
        format.json { render json: { status: "ok" } }
      end
    else
      respond_to do |format|
        format.html { redirect_to(custom_reports_url) }
        format.json { render json: { status: "fail" } }
      end
    end
  end
end
