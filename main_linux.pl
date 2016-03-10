 #!/usr/bin/perl -w
 # Author: security.support@digi.it
 
  use strict;
  use warnings;
  use PACLI_Functions;
  use Text::CSV;  
  
  
  my $VAULT = "VaultLab";
  my $USER = "Pacli";
  my $PARMFILE = "pacli\\vault.ini";
  my $CREDFILE = "pacli\\user.cred";
  my $USER_NAME = $ARGV[0];
  my $HOSTNAME = $ARGV[1];
  my $SAFE = "Devel";
  my $PASSWORD = "Pass.Word";
  my $ACCOUNT_NAME = "root";
  my $FILE = $ACCOUNT_NAME . "@" . $HOSTNAME;
  
  my @result = GetGroupsByUser( $USER_NAME );
  
  
  PACLI_INIT 				( );
  PACLI_DEFINEFROMFILE 		( $VAULT, $PARMFILE );
  PACLI_LOGON				( $VAULT, $USER, $CREDFILE );
  PACLI_OPENSAFE 			( $VAULT, $USER, $SAFE );
  PACLI_STOREPASSWORDOBJECT ( $VAULT, $USER, $SAFE, $FILE, $PASSWORD );
  PACLI_ADDFILECATEGORY     ( $VAULT, $USER, $SAFE, $FILE, "DeviceType", "Operating System" );
  PACLI_ADDFILECATEGORY     ( $VAULT, $USER, $SAFE, $FILE, "PolicyID", "TEST-LinuxSSH" );
  PACLI_ADDFILECATEGORY     ( $VAULT, $USER, $SAFE, $FILE, "Address", $HOSTNAME );
  PACLI_ADDFILECATEGORY     ( $VAULT, $USER, $SAFE, $FILE, "UserName", $ACCOUNT_NAME );
  
  foreach (@result) {
	  PACLI_ADDOWNER   			( $VAULT, $USER, $_, $SAFE );
	  PACLI_ADDRULE				( $VAULT, $USER, $_, $SAFE, "root\\$FILE" );
  }
  
  PACLI_CLOSESAFE 			( $VAULT, $USER, $SAFE );
  PACLI_LOGOFF 				( $VAULT, $USER );
  PACLI_TERM 				( );
