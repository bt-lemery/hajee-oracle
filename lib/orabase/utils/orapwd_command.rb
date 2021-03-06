require 'orabase/utils/ora_command'

module OraUtils
  class OrapwdCommand < OraCommand

    def initialize(options = {})
      super(:orapwd, options)
    end

    def execute(arguments)
      options = {:failonfail => true}
      value = ''
      command = command_string(arguments)
      within_time(@timeout) do
        Puppet.debug "Executing #{@command} command: #{arguments} as #{os_user}"
        value = Puppet::Util::Execution.execute(command, options)
      end
      value
    end

  end
end

