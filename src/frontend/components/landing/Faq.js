import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState } from "react";
function FAQ() {
  let faqs = [{id: 1, q: "How does SkillAtlas determine my career path?", a: "Our AI analyzes the skills in your CV, compares them with real job market data in Kenya, and generates personalized recommendations backed by trends."}, {id: 2, q: "Do I need a CV to get started?", a: "A CV gives the most accurate results, but you can also enter your skills manually and still receive useful insights."}, {id: 3, q: "Is SkillAtlas free to use?", a: "Yes, the core features\u2014CV analysis, skill detection, and career suggestions\u2014are completely free for Kenyan youth."}, {id: 4, q: "What makes SkillAtlas different from other platforms?", a: "SkillAtlas focuses fully on Kenya\u2019s job market, ensuring every insight, skill path, and recommendation is accurate and locally relevant."}, {id: 5, q: "Will my data remain private?", a: "Absolutely. Your CV and personal information are processed securely and never shared with third parties."}];
  let [openIndex, setOpenIndex] = useState(-1);
  function handleToggle(current, index) {
    if (current === index) {
      return -1;
    } else {
      return index;
    }
  }
  function iconFor(isOpen) {
    if (isOpen) {
      return "-";
    } else {
      return "+";
    }
  }
  function answerFor(isOpen, text) {
    if (isOpen) {
      return __jacJsx("p", {"className": "mt-3 text-gray-600 text-base leading-relaxed"}, [text]);
    } else {
      return __jacJsx("div", {}, []);
    }
  }
  return __jacJsx("section", {"className": "bg-white py-16 px-4 sm:py-20 sm:px-6"}, [__jacJsx("div", {"className": "max-w-5xl mx-auto flex flex-col gap-8"}, [__jacJsx("h2", {"className": "text-center text-3xl sm:text-4xl font-bold text-blue-600"}, ["Frequently Asked Questions"]), __jacJsx("div", {"className": "flex flex-col gap-4"}, [faqs.map(item => {
    let isOpen = openIndex === item.id;
    return __jacJsx("div", {"key": item.id, "className": "bg-gray-50 rounded-xl border border-gray-200 shadow-sm p-5 sm:p-6 transition hover:shadow-blue-200 cursor-pointer", "onClick": _ => {
      setOpenIndex(handleToggle(openIndex, item.id));
    }}, [__jacJsx("div", {"className": "flex justify-between items-center"}, [__jacJsx("h3", {"className": "text-lg sm:text-xl font-semibold text-blue-700"}, [item.q]), __jacJsx("span", {"className": "text-2xl font-bold text-blue-600"}, [iconFor(isOpen)])]), answerFor(isOpen, item.a)]);
  })])])]);
}
export { FAQ };
