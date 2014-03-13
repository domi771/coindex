if HDWallet.table_exists?
  begin
  Currency.find_or_create_wallets_from_config
  rescue ActiveRecord::RecordInvalid => e
    shell = Thor::Shell::Color.new
    shell.say e.message, :red
    shell.say "Be sure to assign a valid value to `hdwallet` field(s) in your currency.yml. See currency.yml.example for sample configuration", :red
    exit -1
  end
end
