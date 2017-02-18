require "spec_helper"

describe Squelcher::Range do
  before(:all) { Timecop.freeze(Time.local(2000, 6)) }

  describe '.between' do
    it 'raises an error if ' do
      expect { Squelcher::Range.new.between "" }.to raise_error(ArgumentError)
    end

    it 'should return nothing if there are no dates between the given dates' do
      expect(Squelcher::Range.new.between "22 Nov, 29 Nov").to eq []
    end

    it 'should return one date if there is one date on the same day between the given dates' do
      expect(Squelcher::Range.new.between "22 Nov, 6 Dec").to eq ['29/11/2000']
    end
  end

end
