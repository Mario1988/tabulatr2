#--
# Copyright (c) 2010-2011 Peter Horn, Provideal GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'whiny_hash'

class Tabulatr

  # Hash keeping the defaults for the table options, may be overriden in the
  # table_for call
  TABLE_OPTIONS = WhinyHash.new({ # WhinyHash.new({
    :table_class => 'tabulatr_table',               # class for the actual data table
    :control_div_class_before => 'table-controls',  # class of the upper div containing the paging and batch action controls
    :control_div_class_after => 'table-controls',   # class of the lower div containing the paging and batch action controls
    :paginator_div_class => 'pagination',            # class of the div containing the paging controls

    # which controls to be rendered above and below the tabel and in which order
    :before_table_controls => [:filter, :paginator],
    :after_table_controls => [],

    :table_html => false,              # a hash with html attributes for the table
    :row_html => false,                # a hash with html attributes for the normal trs
    :header_html => false,             # a hash with html attributes for the header trs
    :filter_html => false,             # a hash with html attributes for the filter trs
    :filter => true,                   # false for no filter row at all
    :paginate => false,                # true to show paginator
    :sortable => true,                 # true to allow sorting (can be specified for every sortable column)
    :batch_actions => false,           # :name => value hash of batch action stuff
    :footer_content => false,          # if given, add a <%= content_for <footer_content> %> before the </table>
    :path => '#'                       # where to send the AJAX-requests to
  })

  # these settings are considered constant for the whole application, can not be overridden
  # on a per-table basis.
  # That's necessary to allow find_for_table to work properly
  TABLE_FORM_OPTIONS = WhinyHash.new({
    :filter_postfix => '_filter',               # postfix for name of the filter in the params :hash => xxx_filter
    :sort_postfix => '_sort',                   # postfix for name of the filter in the params :hash => xxx_filter
    :associations_filter => '__association',    # name of the associations in the filter hash
    :batch_postfix => '_batch',                 # postfix for name of the batch action select
    :checked_separator => ','                   # symbol to separate the checked ids
  })

  # these settings are considered constant for the whole application, can not be overridden
  # on a per-table basis.
  # That's necessary to allow find_for_table to work properly
  PAGINATE_OPTIONS = ActiveSupport::HashWithIndifferentAccess.new({
    :page => 1,
    :pagesize => 10,
    :pagesizes => [10, 20, 50]
  })

  # Hash keeping the defaults for the column options
  COLUMN_OPTIONS = ActiveSupport::HashWithIndifferentAccess.new({
    :header => false,                   # a string to write into the header cell
    :width => false,                    # the width of the cell
    :align => false,                    # horizontal alignment
    :valign => false,                   # vertical alignment
    :wrap => true,                      # wraps
    :type => :string,                   # :integer, :date
    :th_html => false,                  # a hash with html attributes for the header cell
    :filter_html => false,              # a hash with html attributes for the filter cell
    :filter => true,                    # false for no filter field,
                                     # container for options_for_select
                                     # String from options_from_collection_for_select or the like
                                     # :range for range spec
                                     # :checkbox for a 0/1 valued checkbox
    :checkbox_value => '1',             # value if checkbox is checked
    :checkbox_label => '',              # text behind the checkbox
    :filter_width => '97%',             # width of the filter <input>
    :range_filter_symbol => '&ndash;',  # put between the <inputs> of the range filter
    :sortable => true,                  # if set, sorting-stuff is added to the header cell
    :format_methods => []               # javascript methods to execute on this column
  })

  # defaults for the find_for_table
  FINDER_OPTIONS = WhinyHash.new({
    :default_order => false,
    :default_pagesize => false,
    :precondition => false,
    :store_data => false,
    :name_mapping => nil,
    :action => nil
  })

  # Stupid hack
  SQL_OPTIONS = WhinyHash.new({
    :like => nil
  })

  def self.finder_options(n=nil)
    FINDER_OPTIONS.merge!(n) if n
    FINDER_OPTIONS
  end

  def self.column_options(n=nil)
    COLUMN_OPTIONS.merge!(n) if n
    COLUMN_OPTIONS
  end

  def self.table_options(n=nil)
    TABLE_OPTIONS.merge!(n) if n
    TABLE_OPTIONS
  end

  def self.paginate_options(n=nil)
    PAGINATE_OPTIONS.merge!(n) if n
    PAGINATE_OPTIONS
  end

  def self.table_form_options(n=nil)
    TABLE_FORM_OPTIONS.merge!(n) if n
    TABLE_FORM_OPTIONS
  end

  def self.table_design_options(n=nil)
    raise("table_design_options stopped existing. Use table_options instead.")
  end
  def table_design_options(n=nil) self.class.table_design_options(n) end

  def self.sql_options(n=nil)
    SQL_OPTIONS.merge!(n) if n
    SQL_OPTIONS
  end
  def sql_options(n=nil) self.class.sql_options(n) end

  COLUMN_PRESETS = {}
  def self.column_presets(n=nil)
    COLUMN_PRESETS.merge!(n) if n
    COLUMN_PRESETS
  end
  def column_presets(n=nil) self.class.column_presets(n) end
  def column_preset_for(name)
    h = COLUMN_PRESETS[name.to_sym]
    return {} unless h
    return h if h.is_a? Hash
    COLUMN_PRESETS[h] || {}
  end
end
