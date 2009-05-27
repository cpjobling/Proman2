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

module ApplicationHelper

  # Title helper as described in RailsCast 30 (http://asciicasts.com/episodes/30-pretty-page-title)
  # Use as <%= :title "Page title" %> in your templates.
  def title(page_title)
    content_for(:title) { page_title }
  end

  # Slogan helper: similar to the title helper. Puts a witty slogan on the current page.
  # Use as <%= :slogan "Plagiarism is bad for your grade" %> in your templates.
  def slogan(page_slogan)
    content_for(:slogan) { page_slogan }
  end

  # tab_helper: returns formatted link for tab menu.
  # useage: tab_helper(:home, :home)
  def tab_helper(tab, active_tab)
    @tabs = {
      :home => {
        :content => "&nbsp; <span>Home</span>",
        :link => root_path
      },
      :admin => {
        :content => "Administer <span>ProMan</span>",
        :link => admin_path,
        :role => "admin"
      },
      :coordinate => {
        :content => "Coordinate <span>Projects</span>",
        :link => coordinate_path,
        :role => "coordinator"
      },
      :my_account => {
        :content => "My <span>Account</account>",
        :link => account_path,
        :role => "user"
      },
      :projects => {
        :content => "View <span>Projects</span>",
        :link => projects_path
      },
      :select_projects => {
        :content => "Select <span>Projects</span>",
        :link => select_projects_path,
        :role => "student"
      },
      :about => {
        :content => "About <span>Proman</span>",
        :link => welcome_path
      }
    }
    if @tabs[tab]
      link = @tabs[tab][:link]
      content = @tabs[tab][:content]
      if active_tab == tab
        active_class = 'class = "active"'
      else
        active_class = ""
      end
      return "<a href='#{link}' #{active_class}>#{content}</a>"
    else
      return ""
    end
  end

  def tab_order
    return [:home, :admin, :coordinate, :my_account, :projects, :select_projects]
  end
end