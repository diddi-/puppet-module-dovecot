class dovecot::auth::ldap (
  $auth_bind         = 'yes',
  $auth_bind_userdn  = undef,
  $base              = undef,
  $dn                = undef,
  $dnpass            = undef,
  $hosts             = undef,
  $pass_attrs        = 'uid=user,userPassword=password',
  $pass_filter       = '(&(objectClass=posixAccount)(uid=%n))',
  $tls               = 'no',
  $user_attrs        = 'homeDirectory=home,uidNumber=uid,gidNumber=gid',
  $user_filter       = '(&(objectClass=posixAccount)(uid=%n))',
) {

  validate_re($auth_bind, '^(yes|no)$', "Invalid value '$auth_bind' in dovecot::auth::ldap::auth_bind. Must be 'yes' or 'no'.")

  if $auth_bind_userdn != undef {
    validate_string($auth_bind_userdn)
  }

  if $base == undef {
    fail("Missing mandatory parameter 'base' in dovecot::auth::ldap.")
  }
  validate_string($base)
 
  if $dn != undef {
    validate_string($dn)
  }

  if $dnpass != undef {
    validate_string($dnpass)
  }

  if $hosts != undef {
    validate_array($hosts)
  }

  validate_string($pass_attrs)
  validate_string($pass_filter)
  validate_re($tls, '^(yes|no)$', "Invalid value '$tls' in dovecot::auth::ldap::tls. Must be 'yes' or 'no'.")
  validate_string($user_attrs)
  validate_string($user_filter)

  file { "$dovecot::confdir_real/dovecot-ldap.conf.ext":
    ensure   => 'file',
    owner    => $dovecot::user,
    group    => $dovecot::group,
    content  => template('dovecot/dovecot-ldap.conf.ext'),
    notify   => Service["${dovecot::service_name_real}"],
    require  => Package[$dovecot::package_name_real],
  }
}
