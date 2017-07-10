package kb_paperblast::kb_paperblastImpl;
use strict;
use Bio::KBase::Exceptions;
# Use Semantic Versioning (2.0.0-rc.1)
# http://semver.org 
our $VERSION = '0.0.1';
our $GIT_URL = 'git@github.com:kbaseapps/kb_paperblast.git';
our $GIT_COMMIT_HASH = 'de02d624ae80a87346f85e109e854d885d324343';

=head1 NAME

kb_paperblast

=head1 DESCRIPTION

This KBase module is a wrapper for PaperBLAST

=cut

#BEGIN_HEADER
use Bio::KBase::AuthToken;
use KBaseReport::KBaseReportClient;
#END_HEADER

sub new
{
    my($class, @args) = @_;
    my $self = {
    };
    bless $self, $class;
    #BEGIN_CONSTRUCTOR
    #END_CONSTRUCTOR

    if ($self->can('_init_instance'))
    {
	$self->_init_instance();
    }
    return $self;
}

=head1 METHODS



=head2 paperblast_seq

  $output = $obj->paperblast_seq($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a kb_paperblast.PaperBLASTSeqParams
$output is a kb_paperblast.PaperBLASTOutput
PaperBLASTSeqParams is a reference to a hash where the following keys are defined:
	ws has a value which is a string
	sequence has a value which is a string
PaperBLASTOutput is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string

</pre>

=end html

=begin text

$params is a kb_paperblast.PaperBLASTSeqParams
$output is a kb_paperblast.PaperBLASTOutput
PaperBLASTSeqParams is a reference to a hash where the following keys are defined:
	ws has a value which is a string
	sequence has a value which is a string
PaperBLASTOutput is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string


=end text



=item Description



=back

=cut

sub paperblast_seq
{
    my $self = shift;
    my($params) = @_;

    my @_bad_arguments;
    (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"params\" (value was \"$params\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to paperblast_seq:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'paperblast_seq');
    }

    my $ctx = $kb_paperblast::kb_paperblastServer::CallContext;
    my($output);
    #BEGIN paperblast_seq
    my $token=$ctx->token;
    my $provenance=$ctx->provenance;

    # only input is AA sequence:
    if (!exists $params->{'sequence'}) {
        die "Parameter 'sequence' is not set in input arguments";
    }
    my $sequence = uc($params->{'sequence'});

    # sanitize sequence
    $sequence =~ s/[^A-Z]//g;
    print("Cleaned up sequence is: $sequence\n");

    # load output into variable
    chdir "/kb/module/dependencies/PaperBLAST/cgi/";
    my $command = './litSearch.cgi "query='.$sequence.'"';
    print("Command is: $command\n");
    my $htmlOutput = `$command`;

    # find any warnings or errors
    my @warnings = [];
    if ($htmlOutput =~ /<ERROR>(.*?)<\/ERROR>/) {
	die $1;
    }
    if ($htmlOutput =~ /<h1>Software error:<\/h1>\n<pre>(.*?)<\/pre>/) {
	die $1;
    }
    if ($htmlOutput =~ /<font color='red'>(.*?)<\/font>/) {
	push @warnings, $1;
    }
    if ($htmlOutput =~ /<p>(Sorry, .*?)<\/p>/) {
	push @warnings, $1;
    }

    # strip HTML header from output
    $htmlOutput =~ s/.*<body>//m;

    # make report
    require "KBaseReport/KBaseReportClient.pm";
    print ("callback url is ".$ENV{ SDK_CALLBACK_URL }."\n");
    my $reportClient = new KBaseReport::KBaseReportClient($ENV{ SDK_CALLBACK_URL },token=>$token);
    my $reportInfo = $reportClient->create_extended_report({ message => "",
							     objects_created => [],
							     warnings => @warnings,
							     html_links => [],
							     direct_html => $htmlOutput,
							     direct_html_link_index => undef,
							     file_links => [],
							     report_object_name => "test",
							     workspace_name => $params->{'ws'} });

    $output = { report_ref => $reportInfo->{'ref'},
		report_name => $reportInfo->{'name'} };

    #END paperblast_seq
    my @_bad_returns;
    (ref($output) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"output\" (value was \"$output\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to paperblast_seq:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'paperblast_seq');
    }
    return($output);
}




=head2 status 

  $return = $obj->status()

=over 4

=item Parameter and return types

=begin html

<pre>
$return is a string
</pre>

=end html

=begin text

$return is a string

=end text

=item Description

Return the module status. This is a structure including Semantic Versioning number, state and git info.

=back

=cut

sub status {
    my($return);
    #BEGIN_STATUS
    $return = {"state" => "OK", "message" => "", "version" => $VERSION,
               "git_url" => $GIT_URL, "git_commit_hash" => $GIT_COMMIT_HASH};
    #END_STATUS
    return($return);
}

=head1 TYPES



=head2 PaperBLASTSeqParams

=over 4



=item Description

Run PaperBLAST against a single sequence


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
ws has a value which is a string
sequence has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
ws has a value which is a string
sequence has a value which is a string


=end text

=back



=head2 PaperBLASTOutput

=over 4



=item Description

PaperBLAST output is just an HTML report


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string


=end text

=back



=cut

1;
