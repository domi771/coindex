require 'spec_helper'

describe Market do

  subject { Market.find('btcchf') }

  its(:id)          { should == 'btcchf' }
  its(:name)        { should == 'BTC/CNY' }
  its(:target_unit) { should == 'btc' }
  its(:price_unit)  { should == 'cny' }

  it "should raise argument error on invalid market id" do
    expect { Market.new(id: 'dogecny') }.to raise_error(ArgumentError)
    expect { Market.new(id: 'dogcny') }.not_to raise_error
  end

end
