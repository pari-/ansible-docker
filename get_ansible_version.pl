#!/usr/bin/env perl

use warnings;
use strict;
use LWP::Simple;
use JSON::XS;
use Data::Dumper;

sub main {
    my $bid = $ENV{'BID'} // 0;

    my $tagged_versions = get_tagged_versions();
    my $last_major_version = get_major_versions( $tagged_versions, -1 )->[-1];
    my $last_four_minor_versions = [
        reverse(
            @{
                get_minor_versions( $tagged_versions, $last_major_version, -4 )
            }
        )
    ];

    my $supported_versions =
      get_supported_versions( $tagged_versions, $last_major_version,
        $last_four_minor_versions );

    print sprintf( "%s.0\n", $supported_versions->[$bid] );
}

sub get_tagged_versions {
    my $tagged_versions = {};

    my $tagged_versions_json =
      get('https://api.github.com/repos/ansible/ansible/git/refs/tags')
      or die "$!";

    foreach my $tag_ref ( @{ decode_json($tagged_versions_json) } ) {

        # we're only interested in v<MAJOR>.<MINOR>.<MICRO>
        if ( $tag_ref->{'ref'} =~
            /^refs\/tags\/v([0-9]+)\.([0-9]+)\.([0-9]+)(?:\.0-1)?$/ )
        {
            my $v = {};
            unless ( exists( $tagged_versions->{$1}->{$2} ) ) {
                $tagged_versions->{$1}->{$2} = $3;
            }
            elsif ( $3 > $tagged_versions->{$1}->{$2} ) {
                $tagged_versions->{$1}->{$2} = $3;
            }
        }
    }

    return $tagged_versions;
}

sub get_supported_versions {
    my ( $tagged_versions, $last_major_version, $last_four_minor_versions ) =
      @_;
    my $supported_versions = [];

    foreach my $minor_version ( @{$last_four_minor_versions} ) {
        push(
            @{$supported_versions},
            sprintf( "%d.%d.%d",
                $last_major_version, $minor_version,
                $tagged_versions->{$last_major_version}->{$minor_version} )
        );
    }

    return $supported_versions;
}

sub get_major_versions {
    my ( $tagged_versions, $i ) = @_;

    return [
        splice( @{ [ sort { $a cmp $b } keys( %{$tagged_versions} ) ] }, $i )
    ];
}

sub get_minor_versions {
    my ( $tagged_versions, $last_major_version, $i ) = @_;

    return [
        splice(
            @{
                [
                    sort { $a cmp $b }
                      keys( %{ $tagged_versions->{$last_major_version} } )
                ]
            },
            $i
        )
    ];
}

main;
