require 'spec_helper'
require 'merb-auth-more/mixins/redirect_back'


shared_examples_for "every call to redirect_back" do

  it "should set the return_to in the session when sent to the exceptions controller from a failed login" do
    r = visit("/go_back")
    r.status.should == Merb::Controller::Unauthenticated.status

    r2 = login
    r2.body.should == "Went back"
  end

  it  "should not set the return_to in the session when deliberately going to unauthenticated" do
    r = login
    r.body.should == "Index"
  end

  it "should still redirect to the original even if it's failed many times" do
    visit("/go_back")
    visit("/login", :put, :pass_auth => false)
    visit("/login", :put, :pass_auth => false)
    visit("/login", :put, :pass_auth => false)

    r = login
    r.body.should == "Went back"
  end

  it "should not redirect back to a previous redirect back after being logged out" do
    visit("/go_back")
    visit("/login", :put, :pass_auth => false)
    visit("/login", :put, :pass_auth => false)
    visit("/login", :put, :pass_auth => false)
    r = login
    r.body.should == "Went back"

    visit("/logout", :delete)
    r = login
    r.body.should == "Index"
  end

end

describe "redirect_back" do

  before(:all) do
    Merb::Config[:exception_details] = true
    clear_strategies!
    Merb::Router.reset!
    Merb::Router.prepare do
      match("/login", :method => :get).to(:controller => "exceptions", :action => "unauthenticated").name(:login)
      match("/login", :method => :put).to(:controller => "sessions", :action => "update")
      match("/go_back").to(:controller => "my_controller", :action => "go_back")
      match("/").to(:controller => "my_controller")
      match("/logout", :method => :delete).to(:controller => "sessions", :action => "destroy")
    end

    class Merb::Authentication
      def store_user(user); user; end
      def fetch_user(session_info); session_info; end
    end

    # class MyStrategy < Merb::Authentication::Strategy; def run!; request.env["USER"]; end; end
    class MyStrategy < Merb::Authentication::Strategy
      def run!
        params[:pass_auth] = false if params[:pass_auth] == "false"
        params[:pass_auth]
      end
    end

    class Application < Merb::Controller; end

    class Exceptions < Merb::Controller
      include Merb::Authentication::Mixins::RedirectBack

      def unauthenticated; end

    end

    class Sessions < Merb::Controller
      before :ensure_authenticated
      def update
        redirect_back_or "/", :ignore => [url(:login)]
      end

      def destroy
        session.abandon!
      end
    end

    class MyController < Application
      before :ensure_authenticated
      def index
        "Index"
      end

      def go_back
        "Went back"
      end
    end

  end

  def login
    visit("/login", :put, :pass_auth => true)
  end

  describe "without Merb::Config[:path_prefix]" do
    before(:all) do
      Merb::Config[:path_prefix] = nil
    end
    it_should_behave_like 'every call to redirect_back'
  end

  describe "without Merb::Config[:path_prefix]" do
    before(:all) do
      Merb::Config[:path_prefix] = '/myapp'
    end
    it_should_behave_like 'every call to redirect_back'
  end

end
