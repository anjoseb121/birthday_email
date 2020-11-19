require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'happy_birthday' do
    let(:user) { create :user }
    let(:mail) { described_class.with(username: user.username, locale: user.locale, email: user.email).happy_birthday.deliver_now }

    before {
      I18n.locale = user.locale
    }

    it 'renders the subject' do
      expect(mail.subject).to eq("#{I18n.t('happy_birthday')} #{user.username}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'translates the body' do
      expect(mail.body.encoded).to match("#{I18n.t('happy_birthday')} #{user.username}")
    end
  end
end
