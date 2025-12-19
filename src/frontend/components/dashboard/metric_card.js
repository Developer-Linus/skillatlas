import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function MetricCard(props) {
  let label = props.get("label");
  let value = props.get("value");
  let value_color = props.get("color", "text-blue-600");
  return __jacJsx("div", {"className": "card text-center fade-in"}, [__jacJsx("p", {"className": "text-sm text-gray-500"}, [label]), __jacJsx("p", {"className": "text-xl font-semibold " + value_color}, [value])]);
}
export { MetricCard };
