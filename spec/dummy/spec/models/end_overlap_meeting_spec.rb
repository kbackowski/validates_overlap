require_relative '../../../spec_helper'
require_relative '../factories/end_overlap_meeting'

describe EndOverlapMeeting do

  before(:all) do
    EndOverlapMeeting.delete_all
  end

  it "create meeting" do
    lambda {
      Factory(:end_overlap_meeting)
    }.should change(EndOverlapMeeting, :count).by(1)
  end

  context "Validation with exclude edges ends_at" do
   @valid_times = {
        "starts at time of end and ends after" => ['2011-01-08'.to_date, '2011-01-19'.to_date]
    }
    
    @not_valid_times = {
          "has same starts_at and ends_at" => ['2011-01-05'.to_date, '2011-01-08'.to_date],
          "starts before starts_at and ends after ends_at" => ['2011-01-04'.to_date, '2011-01-09'.to_date],
          "starts before starts_at and ends inside" => ['2011-01-04'.to_date, '2011-01-06'.to_date],
          "starts inside and ends after ends_at" => ['2011-01-06'.to_date, '2011-01-09'.to_date],
          "starts inside and ends inside" => ['2011-01-06'.to_date, '2011-01-07'.to_date],
          "starts at same time and ends inside" => ['2011-01-05'.to_date, '2011-01-07'.to_date],
          "starts inside and ends at same time" => ['2011-01-06'.to_date, '2011-01-08'.to_date],
          "starts before and ends at time of start" => ['2011-01-03'.to_date, '2011-01-05'.to_date],
      }
    
    @not_valid_times.each do |description, time_range|
      it "is not valid if exists meeting which #{description}" do
        meeting = Factory.build(:end_overlap_meeting, :starts_at => time_range.first, :ends_at => time_range.last)
        meeting.should_not be_valid
        meeting.errors[:starts_at].should_not be_empty
        meeting.errors[:ends_at].should be_empty
      end
    end

    @valid_times.each do |description, time_range|
      it "is valid if exists meeting which #{description}" do
        meeting = Factory.build(:end_overlap_meeting, :starts_at => time_range.first, :ends_at => time_range.last)
        meeting.should be_valid
        meeting.errors[:starts_at].should be_empty
        meeting.errors[:ends_at].should be_empty
      end
    end

  end

end