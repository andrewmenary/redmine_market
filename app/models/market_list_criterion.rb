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

class MarketListCriterion < ActiveRecord::Base
  unloadable
  
  set_table_name "market_list_criteria" # Not "market_list_criterions"!
  belongs_to :market_list
  acts_as_list :scope => :market_list
  
  FIELD_SOURCES = %w(project project_custom version version_custom)
  
  validates_presence_of :field
  validates_uniqueness_of :field, :scope => [:market_list_id]
  validates_inclusion_of :field_source, :in => FIELD_SOURCES

	def to_s
		field
	end
	
	def formatted_value(comparison=nil)
		comparison ||= 'is'
		formatted = nil
    unless value.blank?
			case comparison
			when 'is', '=', '>', '<', '>=', '<='
				case field_type
				when 'string', 'text', 'list'
					formatted = "\'#{value}\'"
				when 'date'
					formatted = begin; value.to_date; rescue; nil end
				when 'bool'
					formatted = (value == '1' ? 1 : 0)
				when 'int'
					formatted = value.to_i
				when 'float'
					formatted = value.to_f
				else
					formatted = value
				end
			when 'in'
				case field_type
				when 'string', 'text', 'list'
					formatted = "\'#{value.split(/,\s*/).join('\',\'')}\'"
				# when 'date'
					# formatted = begin; value.to_date; rescue; nil end
				# when 'bool'
					# formatted = (value == '1' ? 1 : 0)
				# when 'int'
					# formatted = value.to_i
				# when 'float'
					# formatted = value.to_f
				else
					formatted = value
				end
			end
    end
    formatted
  end
	
	def db_casted_qualified_field_name
		casted = nil
		if is_custom_field? then
			# Since the value column in the custom_values table is of type string,
			# we need to convert it to reflect the type of data it contains.
			case field_type
				when 'float'
					casted = "CONVERT(#{qualified_field_name}, DECIMAL(7,2))"
				when 'int'
					casted = "CONVERT(#{qualified_field_name}, INTEGER)"
				when 'date'
					casted = "CONVERT(#{qualified_field_name}, DATETIME)"
			end
		end
		casted ||= qualified_field_name
	end
	
	def is_custom_field?
		["project_custom", "version_custom"].include?(field_source)
	end

	def qualified_field_name
		(is_custom_field?) ? "#{sink_table_alias}.value" : "#{source_table}.#{field}"
	end
	
	# Matrix for Table Joins based on MarketListCriterion.field_source
	#---------------------------------------------------------------------------------+
	# field_source   | source_table | source_id_field | sink_table    | sink_id_field |
	#---------------------------------------------------------------------------------+
	# project        | projects     | id              | versions      | project_id    |
	# project_custom | projects     | id              | custom_values | customized_id |
	# version        | versions     | id              | versions      | id            |
	# version_custom | versions     | id              | custom_values | customized_id |
	#---------------------------------------------------------------------------------+
	def sink_id_field
		case field_source
		when 'project'
			'project_id'
		when 'version'
			'id'
		else
			'customized_id'
		end
	end
	
	def sink_table
		(is_custom_field?) ? 'custom_values' : 'versions'
	end
	
	def sink_table_alias
		(is_custom_field?) ? "table#{position}" : 'versions'
	end
	
	def source_table
	  ["project", "project_custom"].include?(field_source) ? 'projects' : 'versions'
	end
end
