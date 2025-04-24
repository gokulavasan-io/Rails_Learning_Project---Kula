class OrderProcessingJob
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(order_id)
    order = Order.find_by(id: order_id)

    if order
      OrderMailer.order_confirmation(order).deliver_later
      Rails.logger.info "Order ##{order.id} processed and confirmation email sent."
    else
      Rails.logger.error "Order with ID #{order_id} not found."
    end
  end
end
