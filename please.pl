#!/usr/bin/perl
# perl compiler wrapper and release
# perl release manager
##Built on __HOST__ from __FILE__ __TIMESTAMP__ git version v1.__VER__
# replace __DATA__ __PACKAGE__ __TIMESTAMPE__ etc to actual
# put version info between @BEGING @END Lines
# call pp and pipe the replace doce there but with the same name, then pp, create binary
# copy bingary to OneDrive:xor
use File::Basename;
use Getopt::Long;
use POSIX qw(strftime);
use Sys::Hostname;
my $datm = strftime "%a %b %e %H:%M:%S %Y", localtime;


$input="";
$output="";
$compile=1;
$inext="";
$commit=0;
$verbose=0;
$usage="";  ## extract {__USAGE__ to __USAGE__}
GetOptions (
			"commit" => \$commit,	# commit the generated pl file.
			"verbose" => \$verbose,
			"input=s" => \$input,   # show more info;
			"output=s" => \$output    # numeric
			);   # flag
if($input eq "" ) {
print <<FOO;
__<USAGE__
__EXE__ is for perl release management
	__EXE__ -i <file>.pl
	It will compile <file>.pl to <file> and update <file>.readme to <file>.readme.txt as release notes.

##Built on __HOST__ from __FILE__ __TIMESTAMP__ git version v1.__VER__
__USAGE>__

FOO
exit;
}

# __<IGNORE__ begin to ignore conversion

($ifile,$idir,$iext) = fileparse($input, qr/\.[^.]*/);
# dir="/usr/local/src/" file="perl-5.6.1.tar" ext=".gz"

if($output eq "") {
	$output=$input;
	if (".pl" eq $iext) {
		$output=~ s/\.pl/.o.pl/; # each ext handle differently
	}
}




$inbase=basename($input);
$indir=dirname($input);
$outbase=basename($output);
$outdir=dirname($output);
my $ver=qx(cd $indir; git rev-list --count --first-parent HEAD $inbase);
chomp($ver);
$host=hostname;
$gitlog=0;
Please($input, $output, $commit, $compile);
my $readme="$idir$ifile.readme";
if (-e $readme) {
	print "Updating $readme.txt with logs\n";
	Please("$readme", "$readme.txt", $commit, 0); #not compile for readme
}

exit;


sub Please() {

my ($input, $output, $commit, $compile) = @_;
open(IN, '<', $input) or die $!;
open(OUT,'>', $output) or die $!;
my $usagemode=0;
my $gitlog=0;
my $ignoretags=0;
my $ignore="IG"."NORE";  #make sure won't match IGNORE :-)
while(<IN>)
{
	if( index($_, "__<".$ignore."__")>=0){
		$ignoretags=1;
	}
	if( index($_, "__".$ignore.">__")>=0){
		$ignoretags=0;
	}

	if(!$ignoretags)  {
		$_ =~ s/__TIMESTAMP__/$datm/g;
		$_ =~ s/__FILE__/$input/g;
		$_ =~ s/__SOURCE__/$idir$ifile$iext/g;
		$_ =~ s/__EXE__/$idir$ifile/g;
		$_ =~ s/__HOST__/$host/g;
		if ($_ =~ "__VER__") {
			$_ =~ s/__VER__/$ver/g;
			printf "ver=$ver line=\n$_\n" if $verbose;
		}


		
		if( $_ =~ m/__<GITLOG__/ ){
			$gitlog=1;
			print "begin log\n" if $verbose;
			#get all git logs and skip old to __GITLOGEND__
			open LOG, "(cd $indir; git log --date=iso --pretty=format:\"#Log %ad : %s\" $inbase ) |";
			while (<LOG>) {
				print OUT $_;
			}
			print OUT "\n";
			close LOG;
			next; # don't put tag in result
		}
		if ($_ =~ m/__GITLOG>__/) {		#end log
			$gitlog=0;
			print "end of log\n" if $verbose;
			next; # don't put tag in result
		}
		if ($compile) { #process source file, to read usage

			if( $_ =~ m/__<USAGE__/ && !$usagemode){
				$usagemode=1;
				next; #don't put tag in result 
			}
			if(  $_ =~ m/__USAGE>__/) {
				$usagemode=0;
				next; #don't put tag in result 
			}
			$usage = "$usage$_" if ($usagemode);  # put all usage in buffer;


		} else { #in readme file
			if( $_ =~ m/__<USAGE__/ && !$usagemode){
				$usagemode=1;
				print OUT $usage;
				next; # don't put tag in result
			}
			if(  $_ =~ m/__USAGE>__/) {
				$usagemode=0;
				next; # don't put tag in result
			}
		}
	}
	print OUT $_ if (!$gitlog);
}
close(IN);
close(OUT);

### The following should be kept
###Built on __HOST__ from __FILE__ __TIMESTAMP__ git version v1.__VER__

if (".pl" eq $iext && $compile) {
	my $outbin= "$idir$ifile";
	# $outbin =~ s/\.pl//;
	printf ("compiling to $output to $outbin\n");
	system("pp $output -o $outbin");
}

if ($commit) {
	$cmd="cd $outdir; git add $outbase; git commit -m \"Created by Please.pl and compiled on $datm source\" $outbase";
	system($cmd);
}
}
# __IGNORE>__
#Built on __HOST__ from __FILE__ __TIMESTAMP__ git version v1.__VER__
