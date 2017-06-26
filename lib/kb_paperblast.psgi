use kb_paperblast::kb_paperblastImpl;

use kb_paperblast::kb_paperblastServer;
use Plack::Middleware::CrossOrigin;



my @dispatch;

{
    my $obj = kb_paperblast::kb_paperblastImpl->new;
    push(@dispatch, 'kb_paperblast' => $obj);
}


my $server = kb_paperblast::kb_paperblastServer->new(instance_dispatch => { @dispatch },
				allow_get => 0,
			       );

my $handler = sub { $server->handle_input(@_) };

$handler = Plack::Middleware::CrossOrigin->wrap( $handler, origins => "*", headers => "*");
