use strict;
use List::Util qw(min max);
use Math::Trig;
use Geo::SweGrid;
use LWP::Simple qw($ua getstore);

$ua->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:43.0) Gecko/20100101 Firefox/43.0');
$ua->ssl_opts( verify_hostname => 0 );

my $grid = Geo::SweGrid->new("sweref_99_tm") or die "No grid, projection not recognized";

my $base_url = 'https://kso.etjanster.lantmateriet.se/karta/allmannakartor/wms/v1?LAYERS=fjallkartan&EXCEPTIONS=application%2Fvnd.ogc.se_xml&FORMAT=image%2Fpng&TRANSPARENT=TRUE&STYLES=default&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG%3A3006&BBOX=$BBOX&WIDTH=$WIDTH&HEIGHT=$HEIGHT';

my @zoom = (5 .. 12); # 5 .. 12
my @x = (16 .. 18);
my @y = (6 .. 10);
my %north = (min => 6759690, max => 7685281);
my %east  = (min =>  344681, max =>  760174);
my $tiles = 0;

foreach my $zoom (@zoom) {
    print scalar localtime, "\n";
    print "Zoom: $zoom\n";
    my $level_tiles = 0;

    my $zoom_steps = $zoom - $zoom[0];
    my $zoom_factor = 2 ** $zoom_steps;

    my $xmin = $x[0] * $zoom_factor;
    my $xmax = ($x[-1] + 1) * $zoom_factor - 1;

    my $ymin = $y[0] * $zoom_factor;
    my $ymax = ($y[-1] + 1) * $zoom_factor - 1;

    foreach my $y ($ymin .. $ymax) {
        my $row_tiles = 0;
        my $yinv = (1 << $zoom) - $y - 1;

        foreach my $x ($xmin .. $xmax) {
            my ($lon1, $lat1) = tile2lonlat($zoom, $x, $y);
            my ($lon2, $lat2) = tile2lonlat($zoom, $x + 1, $y);
            my ($lon3, $lat3) = tile2lonlat($zoom, $x + 1, $y + 1);
            my ($lon4, $lat4) = tile2lonlat($zoom, $x, $y + 1);

            my ($n1, $e1) = $grid->geodetic_to_grid($lat1, $lon1);
            my ($n2, $e2) = $grid->geodetic_to_grid($lat2, $lon2);
            my ($n3, $e3) = $grid->geodetic_to_grid($lat3, $lon3);
            my ($n4, $e4) = $grid->geodetic_to_grid($lat4, $lon4);

            my ($nmax) = max($n1, $n2);
            my ($nmin) = min($n3, $n4);
            my ($emax) = max($e2, $e3);
            my ($emin) = min($e4, $e1);

            if ($zoom > 5 && (
                $nmax < $north{min} ||
                $nmin > $north{max} ||
                $emax < $east{min} ||
                $emin > $east{max})) {
                next;
            }

            my ($nsize, $esize) = ($nmax - $nmin, $emax - $emin);
            my ($tile_width, $tile_height) = (768, 768);
            my ($x1, $y1) = ($tile_width * ($e1 - $emin) / $esize, $tile_height * ($nmax - $n1) / $nsize);
            my ($x2, $y2) = ($tile_width * ($e2 - $emin) / $esize, $tile_height * ($nmax - $n2) / $nsize);
            my ($x3, $y3) = ($tile_width * ($e3 - $emin) / $esize, $tile_height * ($nmax - $n3) / $nsize);
            my ($x4, $y4) = ($tile_width * ($e4 - $emin) / $esize, $tile_height * ($nmax - $n4) / $nsize);

            my $url = $base_url;
            $url =~ s/\$BBOX/$emin,$nmin,$emax,$nmax/;
            $url =~ s/\$WIDTH/$tile_width/;
            $url =~ s/\$HEIGHT/$tile_height/;

            mkdir $zoom or die $! unless -d $zoom;
            mkdir "$zoom/$x" or die $! unless -d "$zoom/$x";
            my $file_png = "$zoom/$x/$y.png";
            my $file_jpg = "$zoom/$x/$y.jpg";
            getstore($url => $file_png);

            if (-e $file_png) {

                # Skip if fully transparent and zoom > 8
                my $colors = `identify -format %k $file_png`;
                if ($zoom > 8 && $colors == 1) {
                    unlink $file_png;
                    rmdir "$zoom/$x";
                    next;
                }

                # Skip background layer if no area is transparent
                my $bg_options = "$file_png";
                my $file_bg;
                chomp(my $opaque = `identify -format '%[opaque]' $file_png`);
                if ($opaque eq 'false') {
                    my $bg_layer_url = "http://static.hitta.se/tile/v3/4_2x/$zoom/$x/$yinv";
                    $file_bg = "$zoom/$x/$y-bg.png";
                    getstore($bg_layer_url => $file_bg);
                    $bg_options = qq($file_bg -resize "512x512!" $file_png -composite);
                }

                `convert $file_png -distort Perspective "$x1,$y1,0,0 $x2,$y2,511,0 $x3,$y3,511,511 $x4,$y4,0,511" -crop "512x512+0+0" $file_png`;
#                `convert $file_png -fill transparent -stroke green -draw "polyline $x1,$y1 $x2,$y2 $x3,$y3 $x4,$y4" -resize "512x512!" -crop "512x512+0+0" $file_png`;

                `convert $bg_options -strip -sampling-factor "2x2,1x1,1x1" -quality 60 -interlace JPEG $file_jpg`;

                unlink $file_bg if $file_bg;
                unlink $file_png;
            } else {
                warn "File does not exist: $file_png";
            }

            $tiles++;
            $level_tiles++;
            $row_tiles++;
            print '.';
        }

        printf " %.0f%% ",  100 * ($y - $ymin) / ($ymax - $ymin) if $row_tiles;
    }

    print "\n";
    print "Tiles level: $level_tiles\n";
}

print "Tiles: $tiles\n";



sub tile2lonlat {
    my ($zoom, $xtile, $ytile) = @_;
    my $n = 2 ** $zoom;
    my $lon = $xtile / $n * 360.0 - 180.0;
    my $lat = rad2deg(atan(sinh(pi * (1 - 2 * $ytile / $n))));
    return ($lon, $lat);
}
