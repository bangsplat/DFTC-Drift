#!/usr/bin/perl

use strict;

my ( $hour, $minute, $second, $frame );
my $frame_counter = 0;
my $total_frames;
my $timecode;
my $t_ms;
my $drift;

my $frame_duration_ms = (1/(30*(1000/1001)))*1000;

my $ten_minutes = 17982;
my $one_day = 2589408;

$total_frames = $one_day+1;

print "DFTC\n";
print "processing $total_frames frames\n";

$hour = $minute = $second = $frame = 0;

for( $frame_counter = 0; $frame_counter < $total_frames; $frame_counter++ ) {
	# format the current timecode
	$timecode = formatnumber( $hour ) . ":" . formatnumber( $minute ) . ":" . formatnumber( $second ) . ";" . formatnumber( $frame );
	
	# output the current timecode
	print "frame $frame_counter - $timecode ";
	
	print " = " . ( $frame_duration_ms * $frame_counter );
	
	$t_ms = ( $hour * 60 * 60 * 1000 ) + ( $minute * 60 * 1000 ) + ( $second * 1000 ) + ( ( $frame / 30 ) * 1000 );
	$drift = ( $frame_duration_ms * $frame_counter ) - ( $t_ms );
	print " ($drift)";
	
	print "\n";
		
	# increment time code
	
	if ( ++$frame > 29 ) {
		$frame = 0;
		if ( ++$second > 59 ) {
			$second = 0;
			if ( ++$minute > 59 ) {
				$minute = 0;
				++$hour;
			}
		}
	}
	if ( ( $second eq 0 ) && ( $frame eq 0 ) ) {
		# check to see if minutes are evenly divisible by 10
		if ( ( $minute % 10 ) ne 0 ) {
			$frame = 2;
		}
	}
}


sub formatnumber {
	return( sprintf( "%02d", shift(@_) ) );
}
