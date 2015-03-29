class dovecot::mail (
  $gid                   = undef,
  $mail_fsync            = 'optimized',
  $mail_location         = 'mbox:~/mail:INBOX=/var/mail/%u',
  $mmap_disable          = 'no',
  $namespace             = undef,
  $nfs_index             = 'no',
  $nfs_storage           = 'no',
  $shared_maildir        = undef,
  $shared_maildir_user   = 'dovecot',
  $shared_maildir_group  = 'dovecot',
  $uid                   = undef,
) {

  if $gid != undef {
    validate_string($gid)
  }

  validate_re($mail_fsync, '^(optimized|always|never)$', "Invalid value '$mail_fsync' in dovecot::mail::mail_fsync. Must be 'optimized', 'always' or 'never'.")

  validate_string($mail_location)

  validate_re($mmap_disable, '^(yes|no)$', "Invalid value '$mmap_disable' in dovecot::mail::mmap_disable. Must be 'yes' or 'no'.")

  if $namespace != undef {
    validate_hash($namespace)
    create_resources('dovecot::mail::namespaces', $namespace)
  }

  validate_re($nfs_index, '^(yes|no)$', "Invalid value '$nfs_index' in dovecot::mail::nfs_index. Must be 'yes' or 'no'.")
  if $nfs_index == 'yes' and ($mmap_disable == 'no' or $mail_fsync != 'always') {
    fail("dovecot::mail::mmap_disable must be 'no', and dovecot::mail::mail_fsync must be 'always' when dovecot::mail::nfs_index is set to 'yes'.")
  }

  validate_re($nfs_storage, '^(yes|no)$', "Invalid value '$nfs_storage' in dovecot::mail::nfs_storage. Must be 'yes' or 'no'.")
  if $nfs_storage == 'yes' and ($mmap_disable == 'no' or $mail_fsync != 'always') {
    fail("dovecot::mail::mmap_disable must be 'no', and dovecot::mail::mail_fsync must be 'always' when dovecot::mail::nfs_storage is set to 'yes'.")
  }

  if $shared_maildir != undef {
    validate_absolute_path($shared_maildir)
  }

  if $shared_maildir_user != undef {
    validate_string($shared_maildir_user)
  }
  
  if $shared_maildir_group != undef {
    validate_string($shared_maildir_group)
  }

  if $uid != undef {
    validate_string($uid)
  }
  
  file { "${dovecot::confdir_real}/conf.d/10-mail.conf":
    ensure  => 'file',
    owner   => $dovecot::user,
    group   => $dovecot::group,
    content => template('dovecot/10-mail.conf.erb'),
    notify  => Service["${dovecot::service_name_real}"],
  }

  if $shared_maildir != undef {
    user { "$shared_maildir_user":
      ensure => present,
    }

    group { "$shared_maildir_group": 
      ensure => present,
    }
 
    file { "$shared_maildir":
      ensure  => 'directory',
      owner   => $shared_maildir_user,
      group   => $shared_maildir_group,
    }
  }
}
