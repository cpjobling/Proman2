# Copyright 2009 Swansea University
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

require 'test_helper'


class ResearchCentreTest < ActiveSupport::TestCase

  should_validate_presence_of :abbrev, :title, :coordinator
  should_validate_uniqueness_of :abbrev, :title
  should_ensure_length_in_range :abbrev, (3..10)
  should_have_many :supervisors
  should_belong_to :supervisor

  fixtures :research_centres, :supervisors


  test "ResearchCentre title cache works" do
    titles = ResearchCentre::TITLES
    for title in titles do
      db_record = ResearchCentre.find(title[1])
      assert_equal db_record.title, title[0], "Cached ResearchCentre abbrev wasn't #{db_record.title}"
      assert_equal db_record.id, title[1], "Cached id for #{title[1]} was inconsistent with DB record #{db_record.id}"
    end
  end

  test "ResearchCentre abbrev cache works" do
    abbrevs = ResearchCentre::ABBREVS
    for abbrev in abbrevs do
      db_record = ResearchCentre.find(abbrev[1])
      assert_equal db_record.abbrev, abbrev[0], "Cached ResearchCentre abbrev wasn't #{db_record.abbrev}"
      assert_equal db_record.id, abbrev[1], "Cached id for #{abbrev[1]} was inconsistent with DB record #{db_record.id}"
    end
  end

  test "coordinator" do
    rcs = [research_centres(:c2ec), research_centres(:mnc), research_centres(:mrc)]
    coordinators = [supervisors(:mgedwards), supervisors(:pmwilliams), supervisors(:dhisaac)]
    i = 0
    for centre in rcs do
      centre.supervisor = coordinators[i]
      centre.save!
      assert_equal coordinators[i], centre.supervisor, "Coordinator wasn't saved"
      assert coordinators[i].user.has_role?("coordinator"), "Coordinator isn't a coordinator"
    end
  end

  should "return names as a list" do
    ResearchCentre::TITLES.each_with_index do |title, i|
        assert_equal title[0], ResearchCentre.titles[i], "#{ResearchCentre.titles[i]} wasn't #{title}"
    end
  end

  should "return abbreviations as a list" do
    ResearchCentre::ABBREVS.each_with_index do |abbrev, i|
        assert_equal abbrev[0], ResearchCentre.abbreviations[i], "#{ResearchCentre.abbreviations[i]} wasn't #{abbrev}"
    end
  end
end