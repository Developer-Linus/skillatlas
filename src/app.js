import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState } from "react";
function app() {
  let [answer, setAnswer] = useState(0);
  async function computeAnswer() {
    let response = await __jacSpawn("add", "", {"x": 40, "y": 2});
    let result = response.reports;
    setAnswer(result);
  }
  return __jacJsx("div", {}, [__jacJsx("button", {"onClick": computeAnswer}, ["Click Me"]), __jacJsx("div", {}, [__jacJsx("h1", {}, ["Answer:", __jacJsx("span", {}, [answer])])])]);
}
export { app };
