#!/usr/bin/perl
use strict;
use warnings;

use Cwd qw(getcwd chdir);
use Getopt::Long;

# open the project directory
my $dir = '';

GetOptions(
	'dir=s' => \$dir,
) or die "Error in command line arguments\n";


unless ($dir) {
    die "Error: Project directory must be specified.\n";
}

# Change to the main project directory once at the start
chdir($dir) or die "Unable to change to directory $dir : $!";
print "Moved to: " .  getcwd() .  "\n";


# Get a list of project directories in the current directory (relative paths)
opendir( my $dh, "." ) or die "Could not open directory: $!";

my @prj_dirs = grep { -d $_ && $_ !~ /^\.\.?$/ } readdir($dh);


# Loop on each directory and execute 'flutter clean' in it safely
foreach my $fl_dir (@prj_dirs) {
    my $tmp_dir = "$dir/$fl_dir";

    # Construct the full command to run inside the subdirectory.
    # We use system() or backticks for execution, avoiding repeated chdir calls where possible.
    # The 'flutter clean' command is executed within the context of $tmp_dir.
    print "Cleaning directory: $tmp_dir\n";
    
    if (system("cd $tmp_dir && flutter clean")) {
        print "$tmp_dir cleaned successfully.\n";
    } else {
        warn "Failed to execute 'flutter clean' in $tmp_dir.\n";
    }
}