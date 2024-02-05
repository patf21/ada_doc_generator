use strict;
use warnings;

my $source_dir  = "src";
my $output_dir  = "output";

opendir(my $dh, $source_dir) || die "Can't open $source_dir: $!";

while ((my $file = readdir $dh)) {
    next if $file eq '.' or $file eq '..';
    process_file("$source_dir/$file");
}

closedir $dh;

sub process_file {
    my $file = shift;

    # Prepend 'src/' to the file path
    my $src_file = "$file";

    open my $fh, '<', $src_file or die "Can't open $src_file: $!";
    
    my $output_file = "$output_dir/" . (split('/', $file))[-1];
    print "$output_file\n";
    $output_file =~ s/\.ads/.xml/;  # Change file extension to .xml

    open my $out_fh, '>', $output_file or die "Can't open $output_file: $!";

    print $out_fh "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";  # Print XML declaration
    print $out_fh "<root>\n";  # Start root element

    while (<$fh>) {
       
        if (/^--\|(.*)/) {
            # Print XML comment
            print $out_fh "    <!-- $1 -->\n";
        }
    }

    print $out_fh "</root>";  # End root element

    close $fh;
    close $out_fh;
}

sub print_header {
    my ($fh) = @_;

    print $fh "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print $fh "<documentation>\n";
}

sub print_comment {
    my ($fh, $comment) = @_;

    # Assuming a simple XML format
    print $fh "  <comment>$comment</comment>\n";
}

sub print_footer {
    my ($fh) = @_;

    print $fh "</documentation>\n";
}