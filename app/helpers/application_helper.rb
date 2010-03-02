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

  # Headline helper: similar to the title helper. Can be used to give your pages an headline.
  def headline(page_headline)
    content_for(:headline) { page_headline }
  end

  def proman
    return "<em>Proman<sup>&beta;</sup></em>"
  end

  def if_admin?
    yield if logged_in? && current_user.has_role?('admin')
  end

  def if_coordinator?
    yield if logged_in? && current_user.has_role?('coordinator')
  end

  def if_student?
    yield if logged_in? && current_user.has_role?('student')
  end

  def if_supervisor?
    yield if logged_in? && current_user.has_role?('staff')
  end

  def if_logged_in?
    yield if logged_in?
  end

  def in_beta?
    APP_CONFIG['settings']['in_beta']
  end

  def if_in_beta?
    yield if in_beta?
  end

  def unless_in_beta?
    yield unless in_beta?
  end

  def can_allocate?
    status = Status.find(1)
    return status.can_allocate?
  end

  def can_select?
    status = Status.find(1)
    return status.can_select?
  end
end