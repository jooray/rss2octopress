use HTML::WikiConverter;
my $wc = new HTML::WikiConverter( dialect => 'Markdown' );

$html ="";

while (<>) {
	$html.=$_;
}
$_=$wc->html2wiki( $html );
s/<br \/>/  \n/g;
print $_;

