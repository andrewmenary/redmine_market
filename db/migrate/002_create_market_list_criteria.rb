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

class CreateMarketListCriteria < ActiveRecord::Migration
  def self.up
		create_table :market_list_criteria do |t|
			t.references :market_list
			t.references :custom_field
			t.column :field, :string, :null => false
			t.column :field_source, :string, :default => 'version_custom', :null => false
			t.column :field_type, :string
			t.column :operator, :string, :default => 'is', :null => false
			t.column :value, :text
			t.column :position, :integer, :default => 1, :null => false
			t.column :in_order_by, :boolean, :default => 0, :null => false
			t.column :is_order_descending, :boolean, :default => 0, :null => false
			t.timestamps
		end
	end

	def self.down
		drop_table :market_list_criteria
	end
end
