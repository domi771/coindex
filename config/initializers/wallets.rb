if HDWallet.table_exists?
  Currency.find_or_create_wallets_from_config
end
