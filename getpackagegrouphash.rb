module Puppet::Parser::Functions
  newfunction(:getpackagegrouphash, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Return a hash with package names as keys and {ensure => "version of a package"} as values.
    The keys of input hash contains regular expressions which are used to match a list of installed packages.
    For example:
      Input: {apache2* => latest}
      Output: {
                apache2             => {ensure => latest}, 
                apache2-bin         => {ensure => latest}, 
                apache2-data        => {ensure => latest},
                libapache2-mod-wsgi => {ensure => latest}, }
    ENDHEREDOC
    
  value= %x`dpkg -l | grep -E apache2* | awk -F" " '{print $2}'`
  puts value

  puts lookupvar("osfamily") 


  end
end


#    #   getpackagegrouphash($group_packages, keys($static_packages), $::osfamily)
#    
#     dpkg -l | grep -E apache2* | awk -F" " '{print $2}'
#    
#      apache2* : '2.4.7_1ubuntu4.13'
#      grub* : latest
#    
#    
#    
#    module Puppet::Parser::Functions
#      newfunction(:getarrayhash, :type=>:rvalue, :doc=> <<-'ENDHEREDOC') do |args|
#        Creates an array of hashes with keys as args[0] and values as args[1][].
#        Attention! args[0] is a constant, not the array.
#        For example:
#          args[0]="ensure"
#          args[1]=["1ubuntu2.3", "1ubuntu3.4", "latest"]
#          result is [{"ensure" => "1ubuntu2.3"},{"ensure" => "1ubuntu3.4"},{"ensure" => "latest"}]
#    
#        ENDHEREDOC
#    
#        Array.new(args[1].length) {  |index|  Hash[args[0], args[1][index]]  }
#      end
#    end
