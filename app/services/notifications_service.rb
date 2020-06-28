# frozen_string_literal: true

module NotificationsService

  def self.notify_kitchen(order)
    message = "#{order.created_at.to_s(:time)}: incoming order"
    order.user && message = message.dup.concat(" from #{order.user.name}")
    ActionCable
      .server
      .broadcast(
        'kitchen_notifications',
        data: { message: message }
      )
  end


end
