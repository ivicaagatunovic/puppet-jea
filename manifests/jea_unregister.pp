#Unregister JEA endpoint
class puppet-jea::jea_unregister(
  $configname,
) {

#Unregister JEA Endpoint and clean up the config
exec { "Uninstall jea configuration ${configname}" :
    command   => "Unregister-PSSessionConfiguration ${configname} -NoServiceRestart -ErrorAction SilentlyContinue;
                  Remove-Item -Path 'C:\\Program Files\\WindowsPowerShell\\Modules\\JEA' -Force -Recurse -Confirm:\$false -ErrorAction SilentlyContinue;
                  Remove-Item -Path 'C:\\Program Files\\WindowsPowerShell\\PSRemoteConfigurations' -Force -Recurse -Confirm:\$false -ErrorAction SilentlyContinue;",
    logoutput => true,
    provider  => 'powershell',
    onlyif    => "if(((Get-PSSessionConfiguration).name | Select-String -Pattern '${configname}' -SimpleMatch -Quiet) -eq 'True') { exit 0 } else { exit 1 }",
    }

}
