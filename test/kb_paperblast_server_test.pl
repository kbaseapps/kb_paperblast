use strict;
use Data::Dumper;
use Test::More;
use Config::Simple;
use Time::HiRes qw(time);
use Bio::KBase::AuthToken;
use Workspace::WorkspaceClient;
use kb_paperblast::kb_paperblastImpl;

local $| = 1;
my $token = $ENV{'KB_AUTH_TOKEN'};
my $config_file = $ENV{'KB_DEPLOYMENT_CONFIG'};
my $config = new Config::Simple($config_file)->get_block('kb_paperblast');
my $ws_url = $config->{"workspace-url"};
my $ws_name = undef;
my $ws_client = new Workspace::WorkspaceClient($ws_url,token => $token);
my $scratch = $config->{scratch};
my $callback_url = $ENV{'SDK_CALLBACK_URL'};
my $auth_token = Bio::KBase::AuthToken->new(token => $token, ignore_authrc => 1, auth_svc=>$config->{'auth-service-url'});
my $ctx = LocalCallContext->new($token, $auth_token->user_id);
$kb_paperblast::kb_paperblastServer::CallContext = $ctx;
my $impl = new kb_paperblast::kb_paperblastImpl();

sub get_ws_name {
    if (!defined($ws_name)) {
        my $suffix = int(time * 1000);
        $ws_name = 'test_kb_paperblast_' . $suffix;
        $ws_client->create_workspace({workspace => $ws_name});
    }
    return $ws_name;
}


eval {

    # Prepare test data using the appropriate uploader for that data (see the KBase function
    # catalog for help, https://narrative.kbase.us/#catalog/functions)
    
    # Run your method by
    # my $ret = $impl->your_method(parameters...);
    #
    # Check returned data with
    # ok(ret->{...} eq <expected>, "tested item") or other Test::More methods

    my $params = {
	'ws' => get_ws_name(),
	'sequence' => "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    };

    my $rv = $impl->paperblast_seq($params);
    print ("paperblast_seq test\n");
    print Dumper($rv);

    $params->{'sequence'} = "";
    $rv = $impl->paperblast_seq($params);
    print ("paperblast_seq test no sequence\n");
    print Dumper($rv);

    $params->{'sequence'} = "x";
    $rv = $impl->paperblast_seq($params);
    print ("paperblast_seq test x\n");
    print Dumper($rv);
};
my $err = undef;
if ($@) {
    $err = $@;
}
eval {
    if (defined($ws_name)) {
        $ws_client->delete_workspace({workspace => $ws_name});
        print("Test workspace was deleted\n");
    }
};
if (defined($err)) {
    use Scalar::Util 'blessed';
    if(blessed $err && $err->isa("Bio::KBase::Exceptions::KBaseException")) {
        die "Error while running tests. Remote error:\n" . $err->{data} .
            "Client-side error:\n" . $err;
    } else {
        die $err;
    }
}

{
    package LocalCallContext;
    use strict;
    sub new {
        my($class,$token,$user) = @_;
        my $self = {
            token => $token,
            user_id => $user
        };
        return bless $self, $class;
    }
    sub user_id {
        my($self) = @_;
        return $self->{user_id};
    }
    sub token {
        my($self) = @_;
        return $self->{token};
    }
    sub provenance {
        my($self) = @_;
        return [{'service' => 'kb_paperblast', 'method' => 'please_never_use_it_in_production', 'method_params' => []}];
    }
    sub authenticated {
        return 1;
    }
    sub log_debug {
        my($self,$msg) = @_;
        print STDERR $msg."\n";
    }
    sub log_info {
        my($self,$msg) = @_;
        print STDERR $msg."\n";
    }
}
