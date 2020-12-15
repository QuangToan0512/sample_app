class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    I18n.locale = I18n.available_locales.include?(locale) ?
      locale : I18n.default_locale
  end
end
