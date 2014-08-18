If you want to setup a new currency/coin in Peatio please follow these steps:

(example Setup id done with Litecoin) 

### 1) Edit Files

(example Setup id done with Litecoin)

### add currency config to `config/currencies.yml`

    - id: [uniq number]
      key: litecoin
      code: ltc
      coin: true
      rpc: http://username:password@host:port

### add deposit channel to `config/deposit_channels.yml`

    - id: [uniq number]
      key: litecoin
      min_confirm: 1
      max_confirm: 6

### add deposit inheritable model in `app/models/deposits/litecoin.rb`

    module Deposits
      class Litecoin < ::Deposit
        include ::AasmAbsolutely
        include ::Deposits::Coinable
      end
    end

### add deposit inheritable controller in `app/controllers/private/deposits/litecoins_controller.rb`

    module Private
      module Deposits
        class LitecoinsController < BaseController
          include ::Deposits::CtrlCoinable
        end
      end
    end

### for admin control edit the file `app/models/admin/ability.rb` and add these two lines where they belong

     can :manage, ::Deposits::Litecoin
     can :manage, ::Withdraws::Litecoin
    
### make sure to add the new currency/coin as well to the file `config/locales/currency/en.yml`

### 2) Run the generator located at lib/generator

### - Deposit go to `lib/generator/deposit` and run

    rails generate withdraw Litecoin LTC

### - Withdraw go to `lib/generator/deposit` and run

    rails generate deposit Litecoin LTC

### Finished! Restart your Daemons and Rails Server and you have a new coin added to the system
