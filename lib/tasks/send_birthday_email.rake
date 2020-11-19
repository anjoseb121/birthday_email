# frozen_string_literal: true

namespace :emails do
  desc "This task will send an email to all email consented users which birtday is today"
  task send_birthday: :environment do
    BirthdayEmailJob.perform_later
  end
end
