import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function RadialMatchScore(props) {
  let score = "score" in props ? props["score"] : 0;
  return __jacJsx("div", {"className": "flex flex-col items-center gap-2 my-4"}, [__jacJsx("div", {"className": "relative w-32 h-32 rounded-full bg-gradient-to-r from-blue-500 via-teal-400 to-cyan-400 flex items-center justify-center"}, [__jacJsx("div", {"className": "w-24 h-24 bg-white rounded-full flex items-center justify-center"}, [__jacJsx("span", {"className": "text-2xl font-bold text-blue-600"}, [score, "%"])])]), __jacJsx("p", {"className": "text-sm text-gray-600"}, ["Role Match Score"])]);
}
export { RadialMatchScore };
