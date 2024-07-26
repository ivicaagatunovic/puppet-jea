#custom define for setting jea configuration
#this will accept parameters
#lay down the two files based on templates
#then register the file
class puppet-jea::jea_configuration(
  $configname,
  $runasvirtualaccount,
  $transcriptdirectory,
  $sessiontype,
  $roledefinitiondetailstenant,
  $roledefinitiondetailsglobal,
  $roledefinitionstenant,
  $roleassignementglobal,
  $roledefinitions,
  $roledefinitiondetails,
  $scriptstoprocess,
) {
  if $runasvirtualaccount {
    $runasvirtualaccountstring = '$true'
  }
  else {
    $runasvirtualaccountstring = '$false'
  }

  #Define JEA Endpoint Session Configuration file via epp template
  file {"C:/Program Files/WindowsPowerShell/PSRemoteConfigurations/${configname}.pssc":
    ensure  => 'file',
    content => epp("${module_name}/session_configuration_template.epp",
                    { 'sessiontype'               => $sessiontype,
                      'runasvirtualaccountstring' => $runasvirtualaccountstring,
                      'transcriptdirectory'       => $transcriptdirectory,
                      'scriptstoprocess'          => $scriptstoprocess,
                      'roledefinitions'           => $roledefinitions,
                    }
                  ),
    require => Class['puppet-jea::jea_basedirectory'],
  }

  #Apply merged hash content to epp template
  $roledefinitiondetails.each |String $key, Hash $value| {
    file {"C:/Program Files/WindowsPowerShell/Modules/JEA/Rolecapabilities/${key}.psrc":
      ensure  => 'file',
      content => epp("${module_name}/role_capabilities_template.epp",
                      { 'visiblealiases'       => $value['visiblealiases'],
                        'visiblefunctions'     => $value['visiblefunctions'],
                        'visiblecmdlets'       => $value['visiblecmdlets'],
                        'visiblecommands'      => $value['visiblecommands'],
                        'visibleproviders'     => $value['visibleproviders'],
                        'scriptstoprocessrole' => $value['scriptstoprocessrole'],
                        'aliasdefinitions'     => $value['aliasdefinitions'],
                        'functiondefinitions'  => $value['functiondefinitions'],
                        'variabledefinitions'  => $value['variabledefinitions'],
                        'environmentvariables' => $value['environmentvariables'],
                        'typestoprocess'       => $value['typestoprocess'],
                        'formatstoprocess'     => $value['formatstoprocess'],
                        'modulestoimport'      => $value['modulestoimport'],
                      }
                    ),
      require => Class['puppet-jea::jea_basedirectory'],
    }
  }

#Create JEA Endpoint
  exec { "Register configuration ${configname}" :
    command     => "Unregister-PSSessionConfiguration ${configname} -NoServiceRestart -ErrorAction SilentlyContinue; Register-PSSessionConfiguration -Path 'C:\\Program Files\\WindowsPowerShell\\PSRemoteConfigurations\\${configname}.pssc' -Name ${configname} -NoServiceRestart -Force;Start-Sleep -Seconds 10; restart-service Winrm -Force",
    logoutput   => true,
    provider    => 'powershell',
    subscribe   => File["C:/Program Files/WindowsPowerShell/PSRemoteConfigurations/${configname}.pssc"],
    refreshonly => true;
  }
}
