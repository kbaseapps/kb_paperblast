/*
This KBase module is a wrapper for PaperBLAST
*/

module kb_paperblast {
    /*
    Run PaperBLAST against a single sequence
    */
    typedef structure {
	string ws;
	string sequence;
    } PaperBLASTSeqParams;

    /*
    PaperBLAST output is just an HTML report
    */
    typedef structure {
	string report_name;
        string report_ref;
    } PaperBLASTOutput;

    funcdef paperblast_seq(PaperBLASTSeqParams params) returns (PaperBLASTOutput output) authentication required;
};
