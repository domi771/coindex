require 'spec_helper'

feature 'bitcoin deposit address' do
  let!(:identity) { create :identity }
  let!(:member) { create :member, :activated, email: identity.email  }

  let(:address0) { "14jxKES5sRAesjfLyCcggqZzv16maj1wst" }
  let(:address1) { "1PwfjCyi8YJR1ThZDyZ2tXWpuVkcUwQuLL" }

  let(:refresh_button) { ".btn.refresh" }

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
    expect(page).to have_content(address0) # address 0
  end

  scenario 'when address is unused, user does not see a `refresh address` button' do
    go_to_btc_deposit_page
    expect(page).to_not have_selector(".btn.refresh")
  end

  scenario 'when address is used, user can manually refresh address' do
    go_to_btc_deposit_page

    member.get_account('btc').payment_addresses.last.transactions << create(:payment_transaction)

    visit current_url

    expect(page).to have_content(address0)
    expect(page).to have_selector(refresh_button)

    find(refresh_button).click

    expect(page).to have_content(address1)
    expect(page).to_not have_selector(refresh_button)
  end
end
