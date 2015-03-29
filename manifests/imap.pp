class dovecot::imap (
) {

    package { "$dovecot::package_name_imap_real":
      ensure => 'installed',
    }
}
