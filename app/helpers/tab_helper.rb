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
    return navigation(public_tabs, :hover_text => true)
  end

  # return page navigation tabs
  def page_tabs(tabs)
    the_tabs = default_tabs + tabs
    return navigation(order_tabs(the_tabs), :hover_text => true)
  end

  # Return authorized tabs for a page
  def authorized_page_tabs
    return navigation(authorized_tabs, :hover_text => true)
  end

  protected

  def tabs_for_role(role=nil)
    return all_tabs if role == "admin"
    if role == "coordinator"
      if can_allocate?
        return order_tabs([:my_account, :coordinate, :project_allocations])
      else
        return order_tabs([:my_account, :coordinate])
      end
    end
    return order_tabs([:my_account]) if role == "staff"
    if role == "student"
      if can_select?
        return order_tabs([:my_account,:project_selections])
      else
        return order_tabs([:my_account])
      end
    end
    return public_tabs # when user has no roles yet!
  end

  def authorized_tabs
    return public_tabs unless current_user
    ["admin", "coordinator", "staff", "student"].each do |role|
      return tabs_for_role(role) if current_user.has_role?(role)
    end
    return public_tabs # when user has no roles yet!
  end

  def tab_order
    [:home, :my_account, :admin, :coordinate, :projects, :project_allocations, :project_selections, :contact, :news_items, :about]
  end

  # Tabs accessible by visitors
  def public_tabs
    [:home, :projects, :contact, :news_items, :about]
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
      :project_selections => [:project_selections, "Select your projects."],
      :project_allocations => [:project_allocations, "Allocate projects"],
      :my_account => [:my_account, "Go to your account page."],
      :news_items => [:news, "News"]

    }
  end

  def get_tab(tab)
    return get_tabs[tab]
  end

  def all_tabs
    return tab_order
  end

  def can_allocate?
    Status.find(1).can_allocate?
  end

  def can_select?
    Status.find(1).can_select?
  end
end
