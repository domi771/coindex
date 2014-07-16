class ReferralCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && !Member.where(referral_code: value).any?
      record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.models.identity.attributes.referral_code.invalid'))
    end
  end
end
