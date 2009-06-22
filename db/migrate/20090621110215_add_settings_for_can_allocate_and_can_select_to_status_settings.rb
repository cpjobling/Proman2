class AddSettingsForCanAllocateAndCanSelectToStatusSettings < ActiveRecord::Migration
  def self.up
    settings = {
      :offline => {
        :code => 100,
        :can_select => false,
        :can_allocate => false,
        :selection_round => 0
      },
      :pre_registration => {
        :code => 200,
        :can_select => false,
        :can_allocate => false,
        :selection_round => 0
      },
      :registration => {
        :code => 201,
        :can_select => false,
        :can_allocate => false,
        :selection_round => 0
      },
      :pre_selection => {
        :code => 202,
        :can_select => false,
        :can_allocate => false,
        :selection_round => 0
      },
      :selection1 => {
        :code => 203,
        :can_select => true,
        :can_allocate => false,
        :selection_round => 1
      },
      :allocation1 => {
        :code => 204,
        :can_select => false,
        :can_allocate => true,
        :selection_round => 1
      },
      :selection2 => {
        :code => 205,
        :can_select => true,
        :can_allocate => false,
        :selection_round => 2
      },
      :allocation2 => {
        :code => 206,
        :can_select => false,
        :can_allocate => true,
        :selection_round => 2
      },
      :selection3 => {
        :code => 207,
        :can_select => true,
        :can_allocate => false,
        :selection_round => 3
      },
      :allocation3 => {
        :code => 208,
        :can_select => false,
        :can_allocate => true,
        :selection_round => 3
      },
      :allocation4 => {
        :code => 300,
        :can_select => false,
        :can_allocate => true,
        :selection_round => 4
      },
      :post_allocation => {
        :code => 400,
        :can_select => false,
        :can_allocate => false,
        :selection_round => 100
      }
    }
    settings.each do |key, setting|
      status_setting = StatusSetting.find_by_code(setting[:code])
      if status_setting
        status_setting.can_select = setting[:can_select]
        status_setting.can_allocate = setting[:can_allocate]
        status_setting.selection_round = setting[:selection_round]
        status_setting.save
      end
    end
  end
  def self.down
  end
end
