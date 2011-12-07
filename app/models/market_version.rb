#   Market for Redmine
#       A plugin for Redmine to create and display Top 5 lists of Projects
#       according to selectable criteria.
#
#   Copyright (C) 2011  Andrew Menary
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program; if not, write to the Free Software Foundation, Inc.,
#   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#	Authorized source on GitHub at http://github.com/andrewmenary/redmine_market

class MarketVersion < ActiveRecord::Base
	unloadable

	set_table_name "versions"
	
	belongs_to :project,
		:class_name => 'MarketProject',
		:foreign_key => 'project_id',
		:readonly => true
	has_many :custom_values, 
		:class_name => 'MarketCustomValue',
		# :as => :customized, 
		:foreign_key => 'customized_id',
		:conditions => {:customized_type => 'Version'},
		:include => :custom_field,
		:order => "#{CustomField.table_name}.position",
		:readonly => true
	
	def to_s
		name
	end

	# Returns a short description of the version
	def short_description(length = 255)
		description.gsub(/^(.{#{length}}[^\n\r]*).*$/m, '\1...').strip if description
	end
	
	# Get the custom_value record associated with a specific custom_field name.
	def custom_value_by_name(field_name)
		custom_values.detect {|v| v.custom_field.name == field_name}
	end
end
