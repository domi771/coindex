# People exchange commodities in markets. Each market focuses on certain
# commodity pair `{A, B}`. By convention, we call people exchange A for B
# *sellers* who submit *ask* orders, and people exchange B for A *buyers*
# who submit *bid* orders.
#
# ID of market is always in the form "#{B}#{A}". For example, in 'ltcbtc'
# market, the commodity pair is `{btc, chf}`. Sellers sell out _btc_ for
# _chf_, buyers buy in _btc_ with _chf_. _btc_ is the `target`, while _chf_
# is the `price`.

class Market < ActiveYamlBase
  field :visible, default: true

  attr :name, :target_unit, :price_unit

  self.singleton_class.send :alias_method, :all_with_invisible, :all
  def self.all
    all_with_invisible.select &:visible
  end

  def self.enumerize
    all_with_invisible.inject({}) {|hash, i| hash[i.id.to_sym] = i.code; hash }
  end

  # TODO: our market id is the opposite of conventional market name.
  # e.g. our 'ltcbtc' market should use 'ltcbtc' as id, and its name should
  # be 'BTC/CHF'
  def initialize(*args)
    super

    raise ArgumentError, "market id must be 6 chars long (3 chars base currency code + 3 chars quote currency code, e.g. 'ltcbtc')" if id.size != 6

    @target_unit = id[0,3]
    @price_unit  = id[3,3]
    @name = "#{@target_unit}/#{@price_unit}".upcase
  end

  def latest_price
    Trade.latest_price(id.to_sym)
  end

  # type is :ask or :bid
  def fix_number_precision(type, d)
    digits = send(type)['fixed']
    d.round digits, 2
  end

  def to_s
    id
  end

end
