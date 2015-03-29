define dovecot::mail::namespaces (
  $inbox = undef,
) {

  validate_re($inbox, '^(yes|no)$', "Invalid value '$inbox' in dovecot::mail::namespace::${name}::inbox. Must be 'yes' or 'no'.")

}
