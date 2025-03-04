class EchoController < ApplicationController
  def index
    puts params

    @data = params
  end
end
