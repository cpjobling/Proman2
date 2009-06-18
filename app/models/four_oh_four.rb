# == Schema Information
# Schema version: 20090612183400
#
# Table name: four_oh_fours
#
#  id         :integer         not null, primary key
#  url        :string(255)
#  referer    :string(255)
#  count      :integer         default(0)
#  created_at :datetime
#  updated_at :datetime
#

class FourOhFour < ActiveRecord::Base
  def self.add_request(url, referer)
    request = find_or_initialize_by_url_and_referer(url, referer)
    request.count += 1
    request.save
  end
end

