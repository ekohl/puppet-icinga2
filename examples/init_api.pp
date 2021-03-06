class { 'icinga2':
  manage_repo => true,
}

class { '::icinga2::feature::api':
  pki => none,
}

include ::icinga2::pki::ca

#::icinga2::object::apiuser { 'director':
#  ensure      => present,
#  password    => 'Eih5Weefoo2oa8sh', 
#  permissions => [ "*" ],
#  target      => '/etc/icinga2/conf.d/api-users.conf',
#}

::icinga2::object::apiuser { 'icingaweb2':
  ensure      => present,
  password    => '12e2ef553068b519',
  permissions => [ 'status/query', 'actions/*', 'objects/modify/*', 'objects/query/*' ],
  target      => '/etc/icinga2/conf.d/api-users.conf',
}

::icinga2::object::apiuser { 'read':
  ensure      => present,
  password    => 'read',
  permissions => [
    {
      permission => 'objects/query/Host',
      filter     => '{{ regex("^Linux", host.vars.os) }}'
    },
    {
      permission => 'objects/query/Service',
      filter     => '{{ regex("^Linux", host.vars.os) }}'
    },
  ],
  target      => '/etc/icinga2/conf.d/api-users.conf',
}
