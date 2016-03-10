package PACLI_Functions;
use strict;
use warnings;
use Exporter;


# these CAN be exported.
our @ISA= qw( Exporter );
#our @EXPORT_OK = qw( export_me export_me_too );

# these are exported by default.
our @EXPORT = qw( PACLI_INIT
				  PACLI_TERM
				  PACLI_DEFINEFROMFILE
				  PACLI_LOGON
				  PACLI_LOGOFF
				  PACLI_OPENSAFE
				  PACLI_CLOSESAFE
				  PACLI_STOREPASSWORDOBJECT
				  PACLI_ADDFILECATEGORY
				  PACLI_ADDOWNER
				  PACLI_ADDRULE
				  GetGroupsByUser
				);


sub PACLI_INIT {
    return my $result = `PACLI\\PACLI INIT`;
}

sub PACLI_TERM {
    return my $result = `PACLI\\PACLI TERM`;
}

# 0 - Vault Name
# 1 - Parmfile
sub PACLI_DEFINEFROMFILE {
    return my $result = `PACLI\\PACLI DEFINEFROMFILE VAULT=\"$_[0]\" PARMFILE=\"$_[1]\"`;
}

# 0 - Vault Name
# 1 - User Name
# 2 - Logon file
sub PACLI_LOGON {
    return my $result = `PACLI\\PACLI LOGON VAULT=\"$_[0]\" USER=\"$_[1]\" LOGONFILE=\"$_[2]\" AUTOCHANGEPASSWORD=YES`;
}

# 0 - Vault Name
# 1 - User Name
sub PACLI_LOGOFF {
    return my $result = `PACLI\\PACLI LOGOFF VAULT=\"$_[0]\" USER=\"$_[1]\"`;
}

# 0 - Vault Name
# 1 - User Name
# 2 - Safe Name
sub PACLI_OPENSAFE {
    return my $result = `PACLI\\PACLI OPENSAFE VAULT=\"$_[0]\" USER=\"$_[1]\" SAFE=\"$_[2]\"`;
}

# 0 - Vault Name
# 1 - User Name
# 2 - Safe Name
sub PACLI_CLOSESAFE {
    return my $result = `PACLI\\PACLI CLOSESAFE VAULT=\"$_[0]\" USER=\"$_[1]\" SAFE=\"$_[2]\"`;
}

# 0 - Vault Name
# 1 - User Name
# 2 - Safe Name
# 3 - Object Name
# 4 - Password
sub PACLI_STOREPASSWORDOBJECT {
    return my $result = `PACLI\\PACLI STOREPASSWORDOBJECT VAULT=\"$_[0]\" USER=\"$_[1]\" SAFE=\"$_[2]\" FOLDER=\"root\" FILE=\"$_[3]\" PASSWORD=\"$_[4]\"`;
}

# 0 - Vault Name
# 1 - User Name
# 2 - Safe Name
# 3 - Object Name
# 4 - Category
# 5 - Value
sub PACLI_ADDFILECATEGORY {
    return my $result = `PACLI\\PACLI ADDFILECATEGORY VAULT=\"$_[0]\" USER=\"$_[1]\" SAFE=\"$_[2]\" FOLDER=\"root\" FILE=\"$_[3]\" CATEGORY=\"$_[4]\" VALUE=\"$_[5]\"`;
}

# 0 - Vault Name
# 1 - User Name
# 2 - Owner Name
# 3 - Safe
sub PACLI_ADDOWNER {
    return my $result = `PACLI\\PACLI ADDOWNER VAULT=\"$_[0]\" USER=\"$_[1]\" OWNER=\"$_[2]\" SAFE=\"$_[3]\"`;
}


# 0 - Vault Name
# 1 - User Name
# 2 - User Name to authorize
# 3 - Safe Name
# 4 - Object name
sub PACLI_ADDRULE{
    my $result1 = `PACLI\\PACLI ADDRULE VAULT=\"$_[0]\" USER=\"$_[1]\" USERNAME=\"$_[2]\" SAFENAME=\"$_[3]\" FULLOBJECTNAME=\"$_[4]\" EFFECT=Allow RETRIEVE=YES`;
	my $result2 = `PACLI\\PACLI ADDRULE VAULT=\"$_[0]\" USER=\"$_[1]\" USERNAME=\"$_[2]\" SAFENAME=\"$_[3]\" FULLOBJECTNAME=\"$_[4]\" EFFECT=Allow USEPASSWORD=YES`;
	return 0;
}

sub GetGroupsByUser {

	my $user_name=$_[0];
	my $user_id="";
	
  my $file = "users.log";
  open my $fh, "<", $file or die "$file: $!";
  
  my $csv = Text::CSV->new ({
      binary    => 1, # Allow special character. Always set this
      auto_diag => 1, # Report irregularities immediately
      });
  my $row = $csv->getline ($fh);	  
  while ($row = $csv->getline ($fh)) {
	  if ($user_name eq $row->[1]) {$user_id = $row->[0];}
      }
  close $fh;
  if ($user_id eq "") {die "User not found\n";}
  
  my @groups;
  my $file_m = "members.log";
  open my $fh_m, "<", $file_m or die "$file: $!";
  
  my $csv_m = Text::CSV->new ({
      binary    => 1, # Allow special character. Always set this
      auto_diag => 1, # Report irregularities immediately
      });
  my $row_m = $csv_m->getline ($fh_m);	  
  while ($row_m = $csv_m->getline ($fh_m)) {
	  if ($user_id eq $row_m->[1]) {
		push (@groups, $row_m->[0]);
		}
  }
  close $fh_m;
  
  my @usergroups;
  my $file_g = "groups.log";
  open my $fh_g, "<", $file_g or die "$file: $!";
  my $csv_g = Text::CSV->new ({
      binary    => 1, # Allow special character. Always set this
      auto_diag => 1, # Report irregularities immediately
      });
  my $row_g = $csv_g->getline ($fh_g);	  
  while ($row_g = $csv_g->getline ($fh_g)) {
	  foreach (@groups) {
		if ($_ eq $row_g->[0]) {
			#print ("$row_g->[1]\n");
			push (@usergroups, $row_g->[1]);
		}
	  }
	}	  
  close $fh_g;
  
  return @usergroups;

}

1;