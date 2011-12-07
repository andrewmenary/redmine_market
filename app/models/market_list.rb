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

class MarketList < ActiveRecord::Base
	unloadable
  
	has_many :market_list_criterion
  
	def self.find_all_lists
		find(
			:all, 
			:conditions => {:is_visible => true}, 
			:include => :market_list_criterion, 
			:order => 'is_featured DESC, position')
	end
	
	validates_presence_of :name
	validates_uniqueness_of :name

	def to_s
		name
	end
	
	def limit
		@limit ||= 5 #Default to 5, if not yet set
	end
	
	def limit=(new_limit)
		@limit = new_limit
		@list_items = nil	#Reset list data if limit changes
	end
	
	def offset
		@offset ||= 0 #Default to 0, if not yet set
	end
	
	def offset=(new_offset)
		@offset = new_offset
		@list_items = nil #Reset list data if offset changes
	end
		
	def filter
		@filter
	end
	
	# Filter string should be of the form:
	# "table.column=value[&table.column=value]*"
	# For example:
	# "version.status='open'&custom_value.Departmental Owner='Marketing'"
	def filter=(new_filter)
		@filter = new_filter
		@list_items = nil #Reset list data if filter changes
	end
	
	def list_items
		@list_items ||= find_list_items
	end
	
	def find_list_items
		MarketVersion.find(
			:all,
			:conditions => where_clause,
			:joins => join_clause,
			:order => order_by_clause,
			:include => :custom_values,
			:limit => limit,
			:offset => offset
		)
	end
	
	def where_clause
		@where_clause ||= build_where_clause
	end
	
	def build_where_clause
		def add_to_statement(qualified_field_name, operator, value)
		  case operator
			when '=', 'is'
				return "#{qualified_field_name} = #{value}"
			when 'in'
				return "#{qualified_field_name} IN (#{value})"
			when '>'
				return "#{qualified_field_name} > #{value}"
			when '<'
				return "#{qualified_field_name} < #{value}"
			when '>='
				return "#{qualified_field_name} >= #{value}"
			when '<='
				return "#{qualified_field_name} <= #{value}"
			end
		end
		
		statements = []

		for criterion in market_list_criterion
		  case criterion.field_source
			when 'project'
			when 'version'
			when 'project_custom'
				customized_type = 'Project'
				custom_field_type = 'ProjectCustomField'
			when 'version_custom'
				statements << add_to_statement(
					"#{criterion.sink_table_alias}.customized_type", '=', '\'Version\''
					)
				statements << add_to_statement(
					"#{criterion.sink_table_alias}.custom_field_id", '=',	criterion.custom_field_id
					)
				if criterion.value != nil then
					statements << add_to_statement(
						criterion.db_casted_qualified_field_name, criterion.operator, criterion.formatted_value(criterion.operator)
						)
				end
			end
		end
		
		statements.join(' AND ')
	end
	
	def join_clause
		@join_clause ||= build_join_clause
	end
	
	def build_join_clause
		def format_join(source, sink, sink_alias, sink_id)
			"INNER JOIN #{sink} AS #{sink_alias} ON #{source}.id = #{sink_alias}.#{sink_id}"
		end
		
	  joins = []
		for criterion in market_list_criterion
			if criterion.field_source != "version" then #join not needed for version fields
				joins << format_join(criterion.source_table, criterion.sink_table, 
					criterion.sink_table_alias, criterion.sink_id_field)
			end
		end
		
		joins.join(' ')
	end
	
	def order_by_clause
		@order_by_clause ||= build_order_by_clause
	end
	
	def build_order_by_clause
	  order = []
		prefix = ''
		for criterion in market_list_criterion
			if criterion.in_order_by? then
				if criterion.field_type == 'date' then
					prefix = "CASE WHEN #{criterion.db_casted_qualified_field_name} IS NULL THEN 1 ELSE 0 END, "
				end
				if criterion.is_order_descending? then
					order << "#{prefix}#{criterion.db_casted_qualified_field_name} DESC"
				else
					order << "#{prefix}#{criterion.db_casted_qualified_field_name}"
				end
			end
		end
		order << "versions.name"
		
		order.join(', ')
	end
end
