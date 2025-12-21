import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function RadialProgress(percent, size) {
  let radius = size / 2 - 6;
  let circumference = 2 * 3.1416 * radius;
  let offset = circumference * 1 - percent / 100;
  return __jacJsx("div", {"className": "flex justify-center items-center"}, [__jacJsx("svg", {"width": size, "height": size}, [__jacJsx("circle", {"cx": size / 2, "cy": size / 2, "r": radius, "stroke": "var(--color-gray-200)", "stroke-width": "12", "fill": "none"}, []), __jacJsx("circle", {"cx": size / 2, "cy": size / 2, "r": radius, "stroke": "var(--color-primary-500)", "stroke-width": "12", "fill": "none", "stroke-dasharray": circumference, "stroke-dashoffset": offset, "stroke-linecap": "round", "transform": "rotate(-90 " + size / 2 + " " + size / 2 + ")"}, []), __jacJsx("text", {"x": "50%", "y": "50%", "dominant-baseline": "middle", "text-anchor": "middle", "className": "text-lg font-bold", "fill": "var(--color-gray-800)"}, [Math.round(percent) + "%"])])]);
}
export { RadialProgress };
