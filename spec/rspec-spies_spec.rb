require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Spec
  module Matchers
    describe "[object.should] have_received(method, *args)" do
      before do
        @object = String.new("HI!")
      end

      it "does match if method is called with correct args" do
        @object.stub!(:slice)
        @object.slice(5)

        have_received(:slice).with(5).matches?(@object).should be_true
      end

      it "does not match if method is called with incorrect args" do
        @object.stub!(:slice)
        @object.slice(3)

        have_received(:slice).with(5).matches?(@object).should be_false
      end

      it "does not match if method is not called" do
        @object.stub!(:slice)

        have_received(:slice).with(5).matches?(@object).should be_false
      end

      it "correctly lists expects arguments for should" do
        @object.stub!(:slice)

        matcher  = have_received(:slice).with(5, 3)
        messages = matcher.instance_variable_get("@messages")
        message  = messages[:failure_message_for_should].call(@object)
        message.should == "expected \"HI!\" to have received :slice with [5, 3]"
      end

      it "correctly lists expects arguments for should_not" do
        @object.stub!(:slice)

        matcher  = have_received(:slice).with(1, 2)
        messages = matcher.instance_variable_get("@messages")
        message  = messages[:failure_message_for_should_not].call(@object)
        message.should == "expected \"HI!\" to not have received :slice with [1, 2], but did"
      end

      it "does match if method is called with args that match basic argument expectations" do
        @object.stub!(:concat)
        @object.concat("def")

        have_received(:concat).with(kind_of(String)).matches?(@object).should be_true
      end

      it "does match if method is called with args that match a no_args argument expectation" do
        @object.stub!(:downcase)
        @object.downcase

        have_received(:downcase).with(no_args).matches?(@object).should be_true
      end

      it "does match if method is called with args that match a any_args argument expectation" do
        @object.stub!(:slice)
        @object.slice(3, 5)

        have_received(:slice).with(any_args).matches?(@object).should be_true
      end

      it "does match if method is called with args that match a regex arguement expectation" do
        @object.stub!(:concat)
        @object.concat("def")

        have_received(:concat).with(/e/).matches?(@object).should be_true
      end
    end
  end
end
