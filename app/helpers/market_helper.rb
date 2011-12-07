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

module MarketHelper

	# For a specific version, format a boolean custom_value by outputting
	# either a supplied short name or the custom_field name so that if the
	# underlying value is true the output is wrapped in a <strong> tag,
	# otherwise it is plain.
	#
	# Usage: format_boolean_field(@top_priority.at(i), 'Increase Enrollment')
	#	  or format_boolean_field(@top_priority.at(i), 'Increase Enrollment', 'Enrollment')
	def format_boolean_field(version, custom_field_name, short_field_name = nil)
		short_field_name ||= custom_field_name
		# custom_value = version_value_for(version, custom_field_name)
		custom_value = version.custom_value_by_name(custom_field_name)
		if custom_value.custom_field.field_format == 'bool' && custom_value.true? then
			"<strong>#{short_field_name}</strong>"
		else
			short_field_name
		end
	end
  
	def show_label(label_text)
		"<span class=\"top-list-label\">#{label_text}</span>"
	end
	
	def show_detail_item(detail_item)
	  "<span class=\"top-list-detail\">#{detail_item}</span>"
	end
	
	def show_important_detail_item(detail_item)
	  "<stong><span class=\"top-list-important-detail\">#{detail_item}</span></strong>"
	end
	
	def show_detail_line(detail_item, label_text)
		"<span class=\"top-list-detail-line\">#{show_label(label_text)} #{show_detail_item(detail_item)}</span>"
	end
	
	def has_other_lists?(top_lists)
		(top_lists.inject(0) {|count, i| !i.is_featured? ? count + 1 : count}) > 0
	end
end
