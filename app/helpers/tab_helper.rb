#  Copyright 2009 Swansea University.
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#  under the License.

module TabHelper


  def default_tabs
    return navigation public_tabs, :hover_text => true
  end

  # return page navigation tabs
  def page_tabs(tabs)
    the_tabs = default_tabs + tabs
    return navigation order_tabs(the_tabs), hover_text => true
  end

  def authorized_tabs(role = "")
    return all_tabs if role == "admin"
    return order_tabs([:coordinate,:my_account]) if role == "coordinator"
    return order_tabs([:my_account]) if role == "staff"
    return order_tabs([:my_account,:select_projects]) if role == "student"
    return public_tabs
  end

  protected

  def tab_order
    [:home, :admin, :coordinate, :my_account, :projects, :select_projects, :contact, :about]
  end

  # Tabs accessible by visitors
  def public_tabs
    [:home, :projects, :contact, :about]
  end
    
  def order_tabs(additional_tabs)
    all_tabs = public_tabs + additional_tabs
    the_tabs = []
    tab_order.each do |tab|
      the_tabs << tab if all_tabs.include?(tab)
    end
    return the_tabs
  end

  def get_tabs
    return {
      :home => [:home, "Start here."],
      :about => [:about, "About Proman(beta)."],
      :contact => [:contact, "Contact us."],
      :projects => [:projects, "View projects."],
      :admin => [:admin, "Administration tools."],
      :my_account => [:my_account, "Access your account."],
      :select_projects => [:select_projects, "Select your projects."]
      }
  end

  def get_tab(tab)
    return get_tabs[tab]
  end

  def all_tabs
    return tab_order
  end
end
