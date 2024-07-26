# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include puppet-jea
class puppet-jea(
    String $configname,
    Boolean $runasvirtualaccount,
    Boolean $jeaenable,
    String $transcriptdirectory,
    String $sessiontype,
    Hash $roledefinitiondetailstenant = lookup('puppet-jea::rolesettings', {merge => 'hash', value_type => Hash, default_value => {}}),
    Hash $roledefinitiondetailsglobal = lookup('puppet-jea::rolesettings_global', {merge => 'hash', value_type => Hash, default_value => {}}),
    Hash $roledefinitionstenant = lookup('puppet-jea::roleassignement', {merge => 'deep', value_type => Hash, default_value => {}}),
    Hash $roleassignementglobal = lookup('puppet-jea::roleassignement_global', {merge => 'deep', value_type => Hash, default_value => {}}),
    $roledefinitions = deep_merge($roleassignementglobal, $roledefinitionstenant),
    $roledefinitiondetails = deep_merge($roledefinitiondetailstenant, $roledefinitiondetailsglobal),
    Array $scriptstoprocess = [],
) {

if $jeaenable == true {

    class { 'puppet-jea::jea_basedirectory': }
    class { 'puppet-jea::jea_configuration':
        configname                  => $configname,
        runasvirtualaccount         => $runasvirtualaccount,
        transcriptdirectory         => $transcriptdirectory,
        sessiontype                 => $sessiontype,
        roledefinitiondetailstenant => $roledefinitiondetailstenant,
        roledefinitiondetailsglobal => $roledefinitiondetailsglobal,
        roledefinitionstenant       => $roledefinitionstenant,
        roleassignementglobal       => $roleassignementglobal,
        roledefinitions             => $roledefinitions,
        roledefinitiondetails       => $roledefinitiondetails,
        scriptstoprocess            => $scriptstoprocess,
        }
    }

if $jeaenable == false {

    class { 'puppet-jea::jea_unregister':
        configname                  => $configname,
        }
    }


}
