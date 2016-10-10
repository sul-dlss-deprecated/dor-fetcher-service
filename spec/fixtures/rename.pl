#/usr/bin/perl
#
# run as:
#   perl -pi rename.pl file_to_edit

use 5.012;
use warnings;
use strict;

next unless $_;
s/\bpublished_dt\b/published_dttsim/g;
s/\bidentityMetadata_objectType_t\b/objectType_ssim/g;
s/\btitle_t\b/title_ssim/g;
s/\bpublic_dc_title_t\b/dc_title_ssi/g;
s/\bcatkey_id_t\b/catkey_id_ssim/g;
s/\bis_member_of_collection_s\b/is_member_of_collection_ssim/g;
s/\bis_governed_by_s\b/is_governed_by_ssim/g;
