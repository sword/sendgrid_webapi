require 'spec_helper'
require 'middlewares/sendgrid_response'
describe "#newsletter", :vcr do
  let (:client) { SendGridWebApi::Client.new("user", "pass") }
  before(:all) do
    VCR.use_cassette('_newsletter/setup') do
      client.newsletter.add_identity(:identity => 'test_identity',:name => 'test_name', :address => 'address',
        :email => 'bob@example.com', :city => 'test_city', :state => 'test_state',
        :zip => 'test_zip', :country => 'test_country')
    end
  end
  
  after(:all) do
    VCR.use_cassette('_newsletter/teardown') do
      client.newsletter.delete_identity(:identity => 'test_identity')
      client.newsletter.delete(:name => 'test_newsletter')
      client.newsletter.get_lists().each do |list_name|
        client.newsletter.delete_list(:list => list_name)
      end
    end
  end

  describe "newsletters" do
    it "should add newsletter" do
      client.newsletter.add(:identity => "test_identity", :name => "test", :subject => "test_subject", 
        :text => "test_text", :html => "<em>test_html</em>").should == {"message" => "success"}
    end
    it "should edit newsletter" do
      client.newsletter.edit(:identity => "test_identity", :name => "test", :newname => "newtest",
        :subject => "test_subject", :text => "test_text", :html => "<em>test_html</em>")
      .should == {"message" => "success"}
    end
    it "should list newsletters" do
      client.newsletter.list.first["name"].should == "newtest"
    end
    it "should fail to delete a newsletter with invalid name" do
      lambda {
        client.newsletter.delete(:name => "invalid_test_name")
      }.should raise_error(AuthenticationError, /invalid_test_name does not exist/)
    end
    it "should delete newsletter" do
      client.newsletter.delete(:name => "newtest").should == {"message"=>"success"}
    end
  end

  describe "email lists" do
    it "should add list" do
      client.newsletter.add_list(:list => 'test_list', :name => 'email_column')
      .should == {"message" => "success"}
    end
    it "should edit list" do
      client.newsletter.edit_list(:list => 'test_list', :newlist => 'new_list')
      .should == {"message" => "success"}
    end
    it "should get lists" do
      client.newsletter.get_lists.first["list"].should == "new_list"
    end
    it "should delete list" do
      client.newsletter.delete_list(:list => 'new_list')
        .should == {"message" => "success"}
    end

    it "should add list emails" do
      client.newsletter.add_list(:list => 'test_list', :name => 'email')
      client.newsletter.add_list_emails(:list => 'test_list', :data => '{"email":"bob@example.com","name":"contactName"}')
        .should == {"inserted" => 1}
    end
    it "should get list emails" do
      client.newsletter.get_list_emails(:list => 'test_list').first
        .should == {"email" => "bob@example.com","name" => "contactName"}
    end
    it "should delete list emails" do
      client.newsletter.delete_list_emails(:list => 'test_list', :email => 'bob@example.com')
        .should == {"removed" => 1}
    end
  end

  describe "identities" do
    it "should add an identity" do
      client.newsletter.add_identity(:identity => 'second_identity',:name => 'test_name', :address => 'address',
        :email => 'bob@example.com', :city => 'test_city', :state => 'test_state',
        :zip => 'test_zip', :country => 'test_country')
        .should == {"message" => "success"}
    end
    it "should edit an identity" do
      client.newsletter.edit_identity(:identity => 'second_identity',
        :email => 'new@domain.com', :zip => 'new_zip', :replyto => 'new@domain.com')
        .should == {"message" => "success"}
    end
    it "should get an identity" do
      client.newsletter.get_identity(:identity => 'second_identity')
        .should == {"identity" => "second_identity","name" => "test_name", "address" => "address",
          "email" => "new@domain.com", "replyto" => "new@domain.com", "city" => "test_city", 
          "state" => "test_state", "zip" => "new_zip", "country" => "test_country"}
    end
    it "should list identities" do
      client.newsletter.list_identities()
        .should == [{"identity"=>"second_identity"}, {"identity"=>"test_identity"}]
    end
    it "should delete an identity" do
      client.newsletter.delete_identity(:identity => 'second_identity')
        .should == {"message" => "success"}
    end
  end

  pending "recipients" do
    before(:all) do
      VCR.use_cassette('_newsletter/setup_recipients') do
        client.newsletter.add_list(:list => 'second_list', :name => 'email')
        client.newsletter.add_list_emails(:list => 'second_list', :data => '{"email":"bob@example.com","name":"contactName"}')
        p client.newsletter.get_list_emails(:list => 'second_list') ## get sendgrid to refresh their lists
        client.newsletter.add(:identity => "test_identity", :name => "test_newsletter", :subject => "test_subject", 
          :text => "test_text", :html => "<em>test_html</em>")
      end
    end

    after(:all) do
      VCR.use_cassette('_newsletter/teardown_recipients') do
        client.newsletter.delete(:name => "test_newsletter")
        client.newsletter.delete_list(:list => 'second_list')
      end
    end

    it "should add a list of recipients to a newsletter" do
      client.newsletter.add_recipients(:name => 'test_newsletter', :list => 'second_list')
        .should == {"message" => "success"}
    end
    it "should get all lists of recipients for a newsletter" do
      client.newsletter.get_recipients(:name => 'test_newsletter')
        .should == [{"list" => 'second_list'}]
    end
    it "should remove a list of recipients from a newsletter" do
      client.newsletter.remove_recipients(:name => 'test_newsletter', :list => 'second_list')
        .should == {"message" => "success"}
    end
  end

  pending "scheduling" do
    before(:all) do
      VCR.use_cassette('_newsletter/setup_scheduling') do
        client.newsletter.add_list(:list => 'second_list', :name => 'email')
        client.newsletter.add_list_emails(:list => 'second_list', :data => '{"email":"bob@example.com","name":"contactName"}')
        p client.newsletter.get_list_emails(:list => 'second_list') ## get sendgrid to refresh their lists
        client.newsletter.add(:identity => "test_identity", :name => "test_newsletter", :subject => "test_subject", 
          :text => "test_text", :html => "<em>test_html</em>")
      end
    end
    after(:all) do
      VCR.use_cassette('_newsletter/teardown_recipients') do
        client.newsletter.delete(:name => "test_newsletter")
        client.newsletter.delete_list(:list => 'second_list')
      end
    end
    it "should add a schedule for a newsletter at a particular time" do
      test_time = (Time.now + 60*60).utc.iso8601
      client.newsletter.add_schedule(:name => 'test_newsletter', :at => test_time)
      .should == {"message" => "success"}
    end

    it "should delete a schedule for a newsletter" do
      client.newsletter.delete_schedule(:name => 'test_newsletter')
      .should == {"message" => "success"}
    end
    it "should add a schedule for a newsletter at a time in the future" do
      client.newsletter.add_schedule(:name => 'test_newsletter', :after => 120)
      .should == {"message" => "success"}
      client.newsletter.delete_schedule(:name => 'test_newsletter')
    end
  end
end