require 'spec_helper'

feature 'bitcoin deposit address' do
  let!(:identity) { create :identity }
  let!(:member) { create :member, :activated, email: identity.email  }

  before do
    Currency.find_or_create_wallets_from_config
  end

  def go_to_btc_deposit_page
    login identity
    click_on I18n.t 'header.deposit'
    within '.deposit-channel-satoshi' do
      click_on I18n.t 'private.deposits.index.go'
    end
  end

  scenario 'shows the expected address' do
    go_to_btc_deposit_page
    expect(page).to have_content("14jxKES5sRAesjfLyCcggqZzv16maj1wst") # address 0
  end

  scenario 'when address is unused, user does not see a `refresh address` button' do
    go_to_btc_deposit_page
    expect(page).to_not have_selector(".btn.refresh")
  end
end
