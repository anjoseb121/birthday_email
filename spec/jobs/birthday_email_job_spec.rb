# frozen_string_literal: true

require "rails_helper"

RSpec.describe BirthdayEmailJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later }

  let!(:consent) { create :consent, :email_key }

  it "queues the job" do
    expect { job }.to have_enqueued_job(described_class)
  end

  describe "with one email consented user which birthday is today" do
    let(:date) { Time.zone.now }
    let(:other_date) { Time.zone.now + 2.weeks }
    let!(:user_today) { create :user, :consented_email, birthdate: Date.new(1990, date.month, date.day), consent_email: consent }
    let!(:user_not_consented) { create :user, :not_consented_email, birthdate: Date.new(1980, date.month, date.day), consent_email: consent }
    let!(:user_other_day) { create :user, :consented_email, birthdate: Date.new(1990, other_date.month, other_date.day), consent_email: consent }

    it "enqueues one email" do
      perform_enqueued_jobs {
        job
      }
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
  end

  describe "with multiples email consented users which birthday is today" do
    let(:date) { Time.zone.now }
    let(:other_date) { Time.zone.now + 2.weeks }
    let!(:list_today) { create_list :user, 10, :consented_email, birthdate: Date.new(1990, date.month, date.day), consent_email: consent }
    let!(:list_not_consented) { create_list :user, 20, :not_consented_email, birthdate: Date.new(1980, date.month, date.day), consent_email: consent }
    let!(:list_other_day) { create_list :user, 15, :consented_email, birthdate: Date.new(1990, other_date.month, other_date.day), consent_email: consent }
    let!(:list) { create_list :user, 5, :not_consented_email, birthdate: Date.new(1990, other_date.month, other_date.day), consent_email: consent }

    it "enqueues ten emails" do
      perform_enqueued_jobs {
        job
      }
      expect(ActionMailer::Base.deliveries.count).to eq 10
    end
  end
end
