class WebScrapingJob
  include Sidekiq::Worker

  require 'nokogiri'
  require 'net/http'
  require 'uri'
  require 'json'

  def perform(task_id)
    task = Task.find(task_id)
    task.update(status: 'processing')

    begin
      data = prepare_web_scraping(url: task.original_url)

      task.update(status: 'done', collected_data: data)
    rescue StandardError => e
      task.update(status: 'failed', error_message: e)
    end
  end

  def prepare_web_scraping(url:)
    # It's an endpoint of the WebMotor that returns a JSON with the info of the car.
    api_url  = set_api_url(url: url)
    response = Net::HTTP.get_response(URI(api_url))
    
    raise "HTTP Status 403, caused by the captcha" if response.code.to_i == 403
    raise "HTTP #{res.code}" if response.code.to_i != 200

    get_scraping_data(response: response)
  end

  def set_api_url(url:)
    slug_path = url.gsub('https://www.webmotors.com.br/comprar/', '')

    "https://www.webmotors.com.br/api/detail/car/#{slug_path}?pandora=false"
  end

  def get_scraping_data(response:)
    parsed_body = JSON.parse(response.body, symbolize_keys: true)

    {
      car_brand: parsed_body[:Specification][:Make][:Value],
      car_model: parsed_body[:Specification][:Model][:Value],
      car_price: parsed_body[:Prices][:Price]
    }
  end
end
