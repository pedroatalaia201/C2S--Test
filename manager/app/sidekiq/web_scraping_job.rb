class WebScrapingJob
  include Sidekiq::Worker

  def perform(args)
    puts('Im here :)')

    task = Task.find(args)
    task.update(status: 'processing')

    data = scrap_url(url: task.original_url)

    task.update(status: 'done', collected_data: data)
  end

  def scrap_url(url:)
    return { car_model: 'Fox', car_brand: 'VolksWagen', car_price: '25000' }
  end
end
