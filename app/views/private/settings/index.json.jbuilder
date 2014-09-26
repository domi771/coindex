json.accounts @accounts do |account|
  json.code t("account.currency_obj.code", default: account.currency_obj.code)
  json.currency t("currency.name.#{account.currency}", default: account.currency_obj.code.upcase)
  json.available account.balance
  json.locked account.locked
end

json.i18n do
  json.sell I18n.t('private.history.account.sell')
  json.buy I18n.t('private.history.account.buy')
  json.deposit I18n.t('header.deposit')
  json.withdraw I18n.t('header.withdraw')
  json.chf I18n.t('currency.name.chf')
  json.btc I18n.t('currency.name.btc')
  json.ltc I18n.t('currency.name.ltc')
  json.via I18n.t('currency.name.via')
  json.drk I18n.t('currency.name.drk')
  json.ppc I18n.t('currency.name.ppc')
  json.btcd I18n.t('currency.name.btcd')
  json.doge I18n.t('currency.name.doge')
  json.nmc I18n.t('currency.name.nmc')
  json.uro I18n.t('currency.name.uro')
  json.lts I18n.t('currency.name.lts')
  json.sys I18n.t('currency.name.sys')
  json.pts I18n.t('currency.name.pts')
end



