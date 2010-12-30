require 'spec_helper'

describe IndexController do

  describe "GET 'status'" do
    it "should be successful" do
      get 'status'
      response.should be_success
    end
  end

  describe "GET 'parse'" do
    it "should be successful" do
      get 'parse'
      response.should be_success
    end
  end

  describe "GET 'download'" do
    it "should be successful" do
      get 'download'
      response.should be_success
    end
  end

end
