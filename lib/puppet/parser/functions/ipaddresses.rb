module Puppet::Parser::Functions
    newfunction(:ipaddresses, :type => :rvalue, :doc => <<-EOS
Returns all ip addresses of network interfaces (except lo) found by facter.
EOS
    ) do |args|

        begin
          interfaces = lookupvar('interfaces')
        rescue ArgumentError => e
          if e.message == 'uncaught throw :undefined_variable'
            interfaces = nil
          else
            raise
          end
        end

        # In Puppet v2.7, lookupvar returns :undefined if the variable does
        # not exist.  In Puppet 3.x, it returns nil.
        # See http://docs.puppetlabs.com/guides/custom_functions.html
        return false if (interfaces.nil? || interfaces == :undefined)

        result = []
        if interfaces.count(',') > 0
            interfaces = interfaces.split(',')
            interfaces.each do |iface|
                if ! iface.include?('lo')
                    begin
                      ipaddr = lookupvar("ipaddress_#{iface}")
                    rescue ArgumentError => e
                      if e.message == 'uncaught throw :undefined_variable'
                        ipaddr = nil
                      else
                        raise
                      end
                    end
                    begin
                      ipaddr6 = lookupvar("ipaddress6_#{iface}")
                    rescue ArgumentError => e
                      if e.message == 'uncaught throw :undefined_variable'
                        ipaddr6 = nil
                      else
                        raise
                      end
                    end
                    if ipaddr and (ipaddr!= :undefined)
                        result << ipaddr
                    end
                    if ipaddr6 and (ipaddr6!= :undefined)
                        result << ipaddr6
                    end
                end
            end
        else
            if ! interfaces.include?('lo')
                begin
                  ipaddr = lookupvar("ipaddress_#{interfaces}")
                rescue ArgumentError => e
                  if e.message == 'uncaught throw :undefined_variable'
                    ipaddr = nil
                  else
                    raise
                  end
                end
                begin
                  ipaddr6 = lookupvar("ipaddress6_#{interfaces}")
                rescue ArgumentError => e
                  if e.message == 'uncaught throw :undefined_variable'
                    ipaddr6 = nil
                  else
                    raise
                  end
                end
                if ipaddr and (ipaddr!= :undefined)
                    result << ipaddr
                end
                if ipaddr6 and (ipaddr6!= :undefined)
                    result << ipaddr6
                end
            end
        end

        return result
    end
end

