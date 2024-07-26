# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include puppet-jea::jea_basedirectory
class puppet-jea::jea_basedirectory{
  file{'C:/Program Files/WindowsPowerShell/PSRemoteConfigurations':
    ensure => directory,
  }

  file{ 'C:/Program Files/WindowsPowerShell/Modules/JEA':
    ensure => directory,
  }
  file{ 'C:/Program Files/WindowsPowerShell/Modules/JEA/RoleCapabilities':
    ensure  => directory,
    require => File['C:/Program Files/WindowsPowerShell/Modules/JEA'],
  }

}
