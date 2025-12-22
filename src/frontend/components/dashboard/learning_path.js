import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function LearningRoadmap(props) {
  let learning_path = props["learning_path"];
  let target_role = props["target_role"];
  let has_learning_path = false;
  if (learning_path && learning_path["phases"] && learning_path["phases"].length > 0) {
    has_learning_path = true;
  }
  function render_empty_state() {
    return __jacJsx("div", {"className": "text-center py-6"}, [__jacJsx("p", {"className": "text-sm text-gray-500"}, ["We are preparing a personalized learning roadmap for you based on your skill gaps."])]);
  }
  function render_phases() {
    let phase_index = 0;
    return __jacJsx("div", {"className": "timeline"}, [learning_path["phases"].map(phase => {
      let is_active = phase_index === 0;
      let current_phase_number = phase_index + 1;
      phase_index = phase_index + 1;
      let dot_class = "timeline-dot ";
      if (is_active) {
        dot_class = dot_class + "timeline-dot-active";
      } else {
        dot_class = dot_class + "timeline-dot-inactive";
      }
      let card_class = "phase-card ";
      if (is_active) {
        card_class = card_class + "phase-card-active";
      } else {
        card_class = card_class + "phase-card-locked";
      }
      let action_node = null;
      if (is_active) {
        action_node = __jacJsx("button", {"className": "primary-btn text-xs"}, ["Start Phase →"]);
      } else {
        action_node = __jacJsx("span", {"className": "phase-badge phase-badge-locked"}, ["Locked"]);
      }
      return __jacJsx("div", {"className": "relative fade-in"}, [__jacJsx("div", {"className": dot_class}, []), __jacJsx("div", {"className": card_class}, [__jacJsx("div", {"className": "flex justify-between items-center mb-3"}, [__jacJsx("h4", {"className": "font-semibold text-gray-800"}, ["Phase ", current_phase_number, ": ", phase["phase_title"]]), __jacJsx("span", {"className": "text-xs text-gray-500"}, [phase["estimated_time"]])]), __jacJsx("div", {"className": "mb-3"}, [__jacJsx("p", {"className": "text-xs font-medium text-gray-600 mb-1"}, ["Skills you’ll gain"]), __jacJsx("div", {"className": "flex flex-wrap gap-2"}, [phase["skills_targeted"].map(skill => {
        return __jacJsx("span", {"className": "skill-pill"}, [skill]);
      })])]), __jacJsx("div", {"className": "flex justify-between items-center mt-4"}, [__jacJsx("p", {"className": "text-xs text-gray-500"}, [phase["resources_count"], " curated resources"]), action_node])])]);
    })]);
  }
  function render_roadmap_body() {
    if (!has_learning_path) {
      return render_empty_state();
    }
    return render_phases();
  }
  return __jacJsx("div", {"className": "card fade-in"}, [__jacJsx("h3", {"className": "font-semibold mb-4 text-gray-800"}, ["Learning Roadmap to Become ", target_role]), render_roadmap_body()]);
}
export { LearningRoadmap };
