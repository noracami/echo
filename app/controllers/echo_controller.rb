class EchoController < ApplicationController
  skip_forgery_protection only: [ :index ]

  def index
    puts params

    @data = params
  end
end
