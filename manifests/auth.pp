class dovecot::auth (
  $auth_mechanism          = ['plain'],
  $auth_username_format    = '%Lu',
  $disable_plaintext_auth  = 'yes',
  $passdb_args             = undef,
  $passdb_driver           = undef,
  $userdb_args             = undef,
  $userdb_driver           = undef,
) {

  validate_array($auth_mechanism)

  validate_string($auth_username_format)

  validate_re($disable_plaintext_auth, '^(yes|no)$', "Invalid value '$disable_plaintext_auth' for dovecot::auth::disable_plaintext_auth. Must be 'yes' or 'no'.")

  if $passdb_args != undef {
    validate_string($passdb_args)
  }

  if $passdb_driver != undef {
    validate_re($passdb_driver, "^(ldap)$", "Invalid value '$passdb_driver' in dovecot::auth::passdb_driver. Must be 'ldap'.")
  }

  if $userdb_args != undef {
    validate_string($userdb_args)
  }

  if $userdb_driver != undef {
    validate_re($userdb_driver, "^(ldap|static)$", "Invalid value '$userdb_driver' in dovecot::auth::userdb_driver. Must be 'ldap' or 'static'.")
  }


  if $userdb_driver == 'ldap' or $passdb_driver == 'ldap' {
    package { "dovecot-ldap":
      name    => $dovecot::package_name_ldap_real,
      ensure  => 'installed',
    }
    include dovecot::auth::ldap
  }

  file { "${dovecot::confdir_real}/conf.d/10-auth.conf":
    ensure  => 'file',
    owner   => $dovecot::user,
    group   => $dovecot::group,
    content => template('dovecot/10-auth.conf.erb'),
    notify  => Service["${dovecot::service_name_real}"],
  }
}
