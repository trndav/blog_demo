module SubscriptionConcern
    extend ActiveSupport::Concern
    included do
        def check_subscription_status
            # User has payment processor with subscription info
            subscription = payment_processor&.subscription&.processor_subscription
            return if subscription.nil?
            update(
                subscription_status: subscription_status,
                subscription_end_date: Time.at(subscription.current_period_end),
                subscription_start_date: Time.at(subscription.current_period_start))
        end
        def active_subscription
            check_subscription_status if subscription_end_date.nil? || subscription_end_date < 1.months.from_now
            subscription_end_date.nil? ? false: subscription_end_date > 1.months.from_now
        end
    end
end   