class OrderMailer < ApplicationMailer
  default from: "ecommerce@kula.ai"

  def order_confirmation(order)
    @order = order
    @user = order.user
    @order_items = order.order_items
    mail(to: @user.email, subject: "Order Confirmation - ##{@order.id}")
  end
end
