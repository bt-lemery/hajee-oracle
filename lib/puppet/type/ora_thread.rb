require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$:.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'orabase/utils/oracle_access'
require 'orabase/utils/title_parser'

module Puppet
  #
  # Create a new type ora_thread.
  #
  class Type
    newtype(:ora_thread) do
      include EasyType
      include ::OraUtils::OracleAccess
      extend OraUtils::TitleParser

      set_command(:sql)

      desc 'This resource allows you to manage threads in an Oracle database'

      to_get_raw_resources do
        sql_on_all_database_sids %(select thread#, enabled from v$thread)
      end

      on_create do |command_builder|
        statement = "alter database enable thread #{thread_number}"
        command_builder.add(statement, :sid => sid)
      end

      on_modify do |command_builder|
        statement = "alter database #{new_state} thread #{thread_number}"
        command_builder.add(statement, :sid => sid)
      end

      on_destroy do ||
        fail 'You can not delete a thread like this. Stop the database and remove it from the spfile'
      end

      parameter :name
      parameter :thread_number
      parameter :sid

      property  :ensure

      map_title_to_sid(:thread_number) { /^((@?.*?)?(\@.*?)?)$/ }

      def new_state
        self[:ensure].to_s.chop
      end
    end
  end
end
