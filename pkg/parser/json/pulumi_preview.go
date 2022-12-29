package json

import (
	"encoding/json"
	"strings"
	"time"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/pulumi/pulumi/sdk/v3/go/common/display"
	"github.com/rs/zerolog/log"
)

// StepOp represents the kind of operation performed by a step.  It evaluates to its string label.
type StepOp string

// ResourceChanges contains the aggregate resource changes by operation type.
type ResourceChanges map[StepOp]interface{}
type PreviewDigest struct {
	// Config contains a map of configuration keys/values used during the preview. Any secrets will be blinded.
	Config map[string]interface{} `json:"config,omitempty"`

	// Steps contains a detailed list of all resource step operations.
	Steps []*display.PreviewStep `json:"steps,omitempty"`
	// Diagnostics contains a record of all warnings/errors that took place during the preview. Note that
	// ephemeral and debug messages are omitted from this list, as they are meant for display purposes only.
	Diagnostics []display.PreviewDiagnostic `json:"diagnostics,omitempty"`

	// Duration records the amount of time it took to perform the preview.
	Duration time.Duration `json:"duration,omitempty"`
	// ChangeSummary contains a map of count per operation (create, update, etc).
	ChangeSummary display.ResourceChanges `json:"changeSummary,omitempty"`
	// MaybeCorrupt indicates whether one or more resources may be corrupt.
	MaybeCorrupt bool `json:"maybeCorrupt,omitempty"`
}

// KicsPlan is an auxiliary structure for parsing pulumi plans as a KICS Document
type KicsPreview struct {
	Resources map[string]KicsPreviewResource `json:"resources"`
}

// KicsPlanResource is an auxiliary structure for parsing tfplans as a KICS Document
type KicsPreviewResource map[string]KicsPreviewNamedResource

// KicsPlanNamedResource is an auxiliary structure for parsing tfplans as a KICS Document
type KicsPreviewNamedResource interface{}

// parsePulumiPlan unmarshals Document as a plan so it can be rebuilt with only
// the required information
func parsePulumiPlan(doc []byte) (model.Document, error) {
	var preview *PreviewDigest

	// b, err := json.Marshal(doc)
	// if err != nil {
	// 	return model.Document{}, err
	// }
	// Unmarshal our Document as a plan so we are able retrieve steps
	// in a easier way
	// log.Info().Msgf("b %s", b)
	err := json.Unmarshal(doc, &preview)
	if err != nil {
		log.Error().Msgf("JSON is not a Pulumi Preview: %s", err)
		return model.Document{}, err
	}
	parsedPlan := readPulumiPreview(preview)
	return parsedPlan, nil
}

// readPlan will get the information needed and parse it in a way KICS understands it
func readPulumiPreview(preview *PreviewDigest) model.Document {
	kp := KicsPreview{
		Resources: make(map[string]KicsPreviewResource),
	}

	kp.iterateSteps(preview.Steps)

	doc := model.Document{}

	tmpDocBytes, err := json.Marshal(kp)
	if err != nil {
		return model.Document{}
	}
	err = json.Unmarshal(tmpDocBytes, &doc)
	if err != nil {
		return model.Document{}
	}

	return doc
}

// readModule will iterate over all planned_value getting the information required
func (kp *KicsPreview) iterateSteps(steps []*display.PreviewStep) {
	// initialize all the types interfaces
	for i := range steps {
		step := steps[i]
		resourceName := step.NewState.URN.Name().String()
		resourceType := step.NewState.Type.String()
		colonSplitResourceType := strings.Split(resourceType, ":")
		slashSplitResourceType := strings.Split(colonSplitResourceType[1], "/")
		elems := [3]string{colonSplitResourceType[0], slashSplitResourceType[0], colonSplitResourceType[2]}
		localResourceType := strings.Join(elems[:], ":")
		convNamedRes := make(map[string]KicsPreviewNamedResource)
		localInputs := step.NewState.Inputs
		if resourceName != "" {
			kp.Resources[resourceName] = convNamedRes
			kp.Resources[resourceName]["type"] = localResourceType
			kp.Resources[resourceName]["properties"] = localInputs
		}
	}
}
