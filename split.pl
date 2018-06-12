#!/usr/bin/perl

use strict;

@ARGV[0] =~ m/^.*\.(.*)$/ || die;
my $outfilename = $&;
my $docblock = 0;
my $blockcomment = 0;
my $filetype = $1;
if($1 eq 'h') {
	$filetype = 'cpp';
} elsif($& eq 'CMakeLists.txt') {
	$filetype = 'cmake';
}

open(my $infile, '<', @ARGV[0]) || die;
open(my $outfile, '>', 'appskeleton/' . $outfilename) || die;
open(our $docfile, '>', 'doc/' . @ARGV[0] . '.md') || die;

our @blocks;

sub pushline {
	push(@blocks, @_);
}


while(<$infile>) {
	# /* */ comment in a single line
	if(/^\s*\/\*:(.*)\*\//) {
		pushline('doc', $1);
	} elsif(/^\s*\/\*: (.*)/) {
		pushline('doc', $1);
		$blockcomment = 1;
	} elsif($blockcomment) {
		/^\s*\*?\s(.*?)(?:\*\/\s*)?$/;
		pushline('doc', $1);
		$blockcomment = !/\*\//;
	} else {
		if(/^\s*$/) {
			pushline('empty', '');
		} elsif(/^\s*(?:\/\/|#):(.*)?/) {
			pushline('doc', $1);
		} else {
			chomp;
			pushline('content', $_);
		}
	}
}

my $lasttype='doc';
while (my($type, $value) = splice(@blocks, 0, 2)) {
	# print('Type "' . $type . '": "' . $value . "\"\n");
	if($type eq 'doc') {
		print $docfile "```\n\n" unless $lasttype eq $type;
		print $docfile $value . "\n";
		$lasttype = $type;
	} elsif($type eq 'content') {
		print $docfile "\n``` $filetype\n" unless $lasttype eq $type;
		print $docfile $value . "\n";
		print $outfile $value . "\n";
		$lasttype = $type;
	} elsif($type eq 'empty') {
		print $outfile "\n";
	}
}
