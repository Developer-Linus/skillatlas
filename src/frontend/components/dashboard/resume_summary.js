import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function ResumeSummary(props) {
  let summary = props["resume_summary"];
  return __jacJsx("div", {"className": "card fade-in p-6"}, [__jacJsx("div", {"className": "flex items-center mb-3"}, [__jacJsx("div", {"className": "text-primary-500 text-2xl mr-2"}, ["📄"]), __jacJsx("h3", {"className": "font-semibold text-gray-800 text-lg"}, ["Resume Summary"])]), __jacJsx("p", {"className": "text-gray-600 text-sm leading-relaxed"}, [summary])]);
}
export { ResumeSummary };
