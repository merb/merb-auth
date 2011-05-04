require 'spec_helper'

describe "router protection" do

  before(:each) do
    class Foo < Merb::Controller
      def index; "INDEX"; end
      def other; "OTHER"; end
    end

    clear_strategies!

    Object.class_eval do
      remove_const("Mone") if defined?(Mone)
      remove_const("Mtwo") if defined?(Mtwo)
      remove_const("Mthree") if defined?(Mthree)
    end

    Viking.captures.clear

    class Mone < Merb::Authentication::Strategy
      def run!
        Viking.capture self.class
        if request.params[self.class.name]
          request.params[self.class.name]
        elsif request.params[:url]
          redirect!(request.params[:url])
        end
      end
    end

    class Mthree < Mone; end
    class Mtwo < Mone; end

    Merb::Router.prepare do
      to(:controller => "foo") do
        authenticate do
          match("/single_level_default").register

          authenticate(Mtwo) do
            match("/nested_specific").register
          end
        end

        authenticate(Mtwo, Mone) do
          match("/single_level_specific").register
        end

        match("/some").register(:action => 'other')
      end
    end
  end

  describe "single level default" do

    it "should allow access to the controller if the strategy passes" do
      result = visit("/single_level_default", :post, "Mtwo" => true)
      result.body.should == "INDEX"
      Viking.captures.should == %w(Mone Mthree Mtwo)
    end

    it "should fail if no strategies match" do
      result = visit("/single_level_default")
      result.status.should == Merb::Controller::Unauthenticated.status
    end

    it "should set return a rack array if the strategy redirects" do
      result = mock_request("/single_level_default", :post, "url" => "/some/url")
      result.status.should == 302
      result.body.should_not == "INDEX"
    end
  end

  describe "nested_specific" do

    it "should allow access to the controller if the strategy passes" do
      result = visit("/nested_specific", :post, "Mtwo" => true)
      result.body.should == "INDEX"
      Viking.captures.should == %w(Mone Mthree Mtwo)
    end

    it "should fail if no strategies match" do
      result = visit("/nested_specific")
      result.status.should == Merb::Controller::Unauthenticated.status
    end

    it "should set return a rack array if the strategy redirects" do
      result = mock_request("/nested_specific", :post, "url" => "/some/url")
      result.status.should == 302
      result.body.should_not == "INDEX"
    end
  end

  describe "single_level_specific" do

    it "should allow access to the controller if the strategy passes" do
      result = visit("/single_level_specific", :post, "Mone" => true)
      result.body.should == "INDEX"
      Viking.captures.should == %w(Mtwo Mone)
    end

    it "should fail if no strategies match" do
      result = visit("/single_level_specific")
      result.status.should == Merb::Controller::Unauthenticated.status
    end

    it "should set return a rack array if the strategy redirects" do
      result = mock_request("/single_level_specific", :post, "url" => "/some/url")
      result.status.should == 302
      result.body.should_not == "INDEX"
    end
  end

end
