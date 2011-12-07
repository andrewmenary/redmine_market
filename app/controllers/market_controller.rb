#   Market for Redmine - a project marketplace plugin
#   http://github.com/andrewmenary/redmine_market
#
#   Copyright (c) 2011 Andrew Menary
#
#   Permission is hereby granted, free of charge, to any person obtaining a 
#   copy of this software and associated documentation files (the "Software"), 
#   to deal in the Software without restriction, including without limitation 
#   the rights to use, copy, modify, merge, publish, distribute, sublicense, 
#   and/or sell copies of the Software, and to permit persons to whom the 
#   Software is furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in 
#   all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
#   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
#   DEALINGS IN THE SOFTWARE.

class MarketController < ApplicationController
  unloadable

  # A dashboard page highlighting several ordered short-lists (top 5) of project 
  # versions.
  # The first list named Top Ranked is of the first 5 items on the backlog
  # starting with the one having the highest Priority.
  def index
		list
		render :action => 'list'
  end

  def list
		@top_lists = MarketList.find_all_lists
		for top_list in @top_lists
			top_list.limit = 5
		end
  end
  
	def show
		@top_list = MarketList.find(params[:id])
		@top_list.limit = 100
	end
end
