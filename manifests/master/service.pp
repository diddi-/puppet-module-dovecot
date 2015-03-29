define dovecot::master::service (
  $listener  = undef,
  $mode      = undef,
  $name      = undef,
  $port      = undef,
  $proto     = undef,
  $ssl       = undef,
) {

  if $listener != undef {
    validate_re($listener, '^(inet|unix)$', "Invalid value '$listener' in dovecot::master::service::${name}::listener. Must be 'inet' or 'unix'.")
  }

  if $mode != undef {
    validate_re($mode, '^\d{4}$', "Invalid value '$mode' in dovecot::master::service::${name}::mode. Must be a four-digit number.")
  }

  if $port != undef {
    validate_re($port, '^\d+$', "Invalid value '$port' in dovecot::master::service::${name}::mode. Must be an integer between 1 and 65535")

    if $port < 1 or $port > 65535 {
      fail("Invalid value '$port' in dovecot::master::service::${name}::mode. Must be an integer between 1 and 65535")
    }
  }

  if $proto != undef {
    validate_re($proto, '^(imap|imaps|pop3|pop3s)$', "Invalid value '$proto' in dovecot::master::service::${name}::proto. Must be 'imap', 'imaps', 'pop3' or 'pop3s'.")
  }

  if $ssl != undef {
    validate_re($ssl, '^(yes|no)$', "Invalid value '$ssl' in dovecot::master::service::${name}::ssl. Must be 'yes' or 'no'.")
  }
}
