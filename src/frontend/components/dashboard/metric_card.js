import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function MetricCard(props) {
  let label = "label" in props ? props["label"] : "Metric";
  let value = "value" in props ? props["value"] : "0";
  let value_color = "color" in props ? props["color"] : "text-blue-600";
  return __jacJsx("div", {"className": "card text-center fade-in"}, [__jacJsx("p", {"className": "text-sm text-gray-500"}, [label]), __jacJsx("p", {"className": "text-xl font-semibold " + value_color}, [value])]);
}
export { MetricCard };
