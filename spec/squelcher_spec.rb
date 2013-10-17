require "spec_helper"
require "timecop"

describe Squelcher do
  before(:all) { Timecop.freeze(Time.local(2000)) }
  
  describe "#squelch" do
    subject(:squelch) { Squelcher.squelch(@date_string) }
    let(:first_date_in) { "01/02/2013" }
    let(:first_date_out) { "01/02/2013" }
    let(:last_date_in) { "01/01/1970" }
    let(:last_date_out) { "01/01/1970" }
    
    context "when given non-date input" do
      before { @date_string = "foobar" }
      it "should raise an appropriate error" do
        expect { squelch }.to raise_error(Squelcher::ParseError)
      end
    end

    it "should pass a single DD/MM/YYYY date through" do
      @date_string = first_date_in
      squelch.should == [first_date_out]
    end

    shared_examples "squelch" do
      it "should return an array" do
        squelch.should be_an(Array)
      end
      it "should include the first date" do
        squelch.should include first_date_out
      end
      it "should include the last date" do
        squelch.should include last_date_out
      end
    end   

    context "given a comma-separated string of DD/MM/YYYY dates" do
      before { @date_string = "#{first_date_in},#{last_date_in}" }
      it_should_behave_like "squelch"
    end
    context "when there are spaces in the comma-separated string" do
      before { @date_string = "  #{first_date_in}  , #{last_date_in}  " }
      it_should_behave_like "squelch"
    end
    context "when the dates are on different lines" do
      before(:each) do
        @date_string = %{#{first_date_in}
#{last_date_in}}
      end
      it_should_behave_like "squelch"
    end
    
    Date::DAYNAMES.each do |day|
      context "given dates with a #{day} in front" do
        let(:first_date_in) { "#{day} 13th October" }
        let(:first_date_out) { "13/10/2000" }
        let(:last_date_in) { "#{day} 15th December" }
        let(:last_date_out) { "15/12/2000" }
        before { @date_string = %{#{first_date_in}, #{last_date_in } } }
        it_should_behave_like "squelch"
      end
    end
    
    context "given a Swing Patrol style date list" do
      let(:first_date_in) { "13th October" }
      let(:first_date_out) { "13/10/2000" }
      let(:last_date_in) { "15th December" }
      let(:last_date_out) { "15/12/2000" }
      before(:each) do
        @date_string = %{#{first_date_in}
20th October
3rd November
10th November
1tth November
1st December
#{last_date_in}}
      end
      it_should_behave_like "squelch"
    end
    context "given a Swing Patrol style date list with days" do
      let(:first_date_in) { "Sunday 13th October" }
      let(:first_date_out) { "13/10/2000" }
      let(:last_date_in) { "Sunday 15th December" }
      let(:last_date_out) { "15/12/2000" }
      before(:each) do
        @date_string = %{#{first_date_in}
Sunday 20th October
Sunday 3rd November
Sunday 10th November
Sunday 17th November
Sunday 1st December
#{last_date_in}}
      end
      it_should_behave_like "squelch"
    end
  end
end
