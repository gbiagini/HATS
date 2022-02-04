#!/usr/bin/perl -w

# Author: Kazutoyo Osoegawa, Ph.D.
# Developed at Stanford Blood Center
# email: kazutoyo@stanford.edu
# phone: 650-724-0169

# module: QAllele.pm 
# This module was developed to capture Q alleles
# last modified and documented on March 12 2020

package QAllele;
use strict;

my $date = `date +%F`;          # invoke bash date command
chomp $date;    # remove newline character

sub all {		# deal with remaining serotypes with strict mode
	my ($fasta_ref, $gene) = @_;

	my %QAllele;
	my $QAllele_ref = \%QAllele;
	foreach my $head ( keys %$fasta_ref ) {
		if ( $head =~ /HLA:\S+ ($gene\*\d+:\d+:*\d*:*\d*\S*) \d+ bp/ ) {
			my $allele = $1;
			if ( $allele =~ /[0-9]+Q/ ) {	# exclude Q allele
				$QAllele { $allele } = "Questionable";
			}
		}
	}

	print "Number on Q Alleles of " . $gene . ": " . scalar ( keys %QAllele ) . "\n";
	open(FILE, ">output/QAllele_" . $gene . "_" . $date . ".csv");
	foreach my $allele ( sort ( keys %QAllele ) ) {
		print FILE $allele . "\n";
	}
	close FILE;

	return $QAllele_ref;
}

1;
