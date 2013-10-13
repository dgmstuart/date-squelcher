require "spec_helper"

describe Squelcher do
  describe "#squelch" do
    subject(:squelch) { Squelcher.squelch(@date_string) }
    let(:first_date_in) { "01/02/2013" }
    let(:first_date_out) { "01/02/2013" }
    let(:last_date_in) { "01/01/1970" }
    let(:last_date_out) { "01/01/1970" }


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
    context "given a Swing Patrol style date list" do
      let(:first_date_in) { "13th October" }
      let(:first_date_out) { "13/10/2013" }
      let(:last_date_in) { "15th December" }
      let(:last_date_out) { "15/12/2013" }
      before(:each) do
        @date_string = %{#{first_date_in}
20th October
3rd November
10th November
17tth November
1st December
#{last_date_in}}
      end
      it_should_behave_like "squelch"
    end
  end
end