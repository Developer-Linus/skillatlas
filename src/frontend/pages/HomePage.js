import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { Header } from "../components/layout/Header.js";
import { Hero } from "../components/hero/Hero.js";
import { ValueProposition } from "../components/landing/ValueProposition.js";
import { Features } from "../components/landing/Features.js";
import { HowItWorks } from "../components/landing/HowItWorks.js";
import { FAQ } from "../components/landing/Faq.js";
import { Footer } from "../components/layout/Footer.js";
function HomePage() {
  return __jacJsx("div", {"className": "min-h-screen bg-gray-50 text-gray-900 font-sans"}, [__jacJsx(Header, {}, []), __jacJsx(Hero, {}, []), __jacJsx(ValueProposition, {}, []), __jacJsx(Features, {}, []), __jacJsx(HowItWorks, {}, []), __jacJsx(FAQ, {}, []), __jacJsx(Footer, {}, [])]);
}
export { HomePage };
