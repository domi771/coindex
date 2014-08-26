require 'spec_helper'

describe Market do

  subject { Market.find('ltcbtc') }

  its(:id)          { should == 'ltcbtc' }
  its(:name)        { should == 'BTC/CHF' }
  its(:target_unit) { should == 'btc' }
  its(:price_unit)  { should == 'chf' }

  it "should raise argument error on invalid market id" do
    expect { Market.new(id: 'dogechf') }.to raise_error(ArgumentError)
    expect { Market.new(id: 'dogchf') }.not_to raise_error
  end

end
