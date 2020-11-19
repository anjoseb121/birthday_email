# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def happy_birthday
    @username = params[:username]
    email = params[:email]
    I18n.locale = params[:locale]
    subject = "#{I18n.t('happy_birthday')} #{@username}"
    mail(to: email, subject: subject)
  end
end
