
package us.kbase.kbpaperblast;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


/**
 * <p>Original spec-file type: PaperBLASTSeqParams</p>
 * <pre>
 * Run PaperBLAST against a single sequence
 * </pre>
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "ws",
    "sequence"
})
public class PaperBLASTSeqParams {

    @JsonProperty("ws")
    private String ws;
    @JsonProperty("sequence")
    private String sequence;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("ws")
    public String getWs() {
        return ws;
    }

    @JsonProperty("ws")
    public void setWs(String ws) {
        this.ws = ws;
    }

    public PaperBLASTSeqParams withWs(String ws) {
        this.ws = ws;
        return this;
    }

    @JsonProperty("sequence")
    public String getSequence() {
        return sequence;
    }

    @JsonProperty("sequence")
    public void setSequence(String sequence) {
        this.sequence = sequence;
    }

    public PaperBLASTSeqParams withSequence(String sequence) {
        this.sequence = sequence;
        return this;
    }

    @JsonAnyGetter
    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public String toString() {
        return ((((((("PaperBLASTSeqParams"+" [ws=")+ ws)+", sequence=")+ sequence)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
