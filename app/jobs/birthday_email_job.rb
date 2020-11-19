# frozen_string_literal: true

class BirthdayEmailJob < ApplicationJob
  queue_as :default

  def perform
    today = Time.zone.now
    users = User.consented_to(Consent.find_by(key: "email"))
                .birthday_by_date(today)
    users.distinct.find_each(batch_size: 1000) do |user|
      UserMailer.with(username: user.username, locale: user.locale, email: user.email)
                .happy_birthday
                .deliver_later
    end
  end
end
